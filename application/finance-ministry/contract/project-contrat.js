/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Fabric smart contract classes
const { Contract, Context } = require('fabric-contract-api');

// PaperNet specifc classes
const Project = require('./project.js');
const ProjectList = require('./projectlist.js');
const QueryUtils = require('./queries.js.js');

/**
 * A custom context provides easy access to list of all commercial papers
 */
class ProjectContext extends Context {

    constructor() {
        super();
        // All papers are held in a list of papers
        this.ProjectList = new ProjectList(this);
    }

}

/**
 * Define commercial paper smart contract by extending Fabric Contract class
 *
 */
class ProjectContract extends Contract {

    constructor() {
        // Unique namespace when multiple contracts per chaincode file
        super('org.healthnet.Project');
    }

    /**
     * Define a custom context for commercial paper
    */
    createContext() {
        return new ProjectContext();
    }

    /**
     * Instantiate to perform any setup of the ledger that might be required.
     * @param {Context} ctx the transaction context
     */
    async instantiate(ctx) {
        // No implementation required with this example
        // It could be where data migration is performed, if necessary
        console.log('Instantiate the contract');
    }

    /**
     * Issue commercial paper
     *
     * @param {Context} ctx the transaction context
     * @param {String} issuer project issuer
     * @param {Integer} paperNumber paper number for this issuer
     * @param {String} issueDateTime paper issue date
     * @param {String} maturityDateTime paper maturity date
     * @param {Integer} faceValue face value of paper
    */
    async issue(ctx, issuer, paperNumber, issueDateTime, maturityDateTime, faceValue) {

        // create an instance of the paper
        let paper = Project.createInstance(issuer, paperNumber, issueDateTime, maturityDateTime, parseInt(faceValue));

        // Smart contract, rather than paper, moves paper into ISSUED state
        paper.setIssued();

        // save the owner's MSP 
        let mspid = ctx.clientIdentity.getMSPID();
        paper.setIssuerMSP(mspid);

        // Newly issued paper is owned by the issuer to begin with (recorded for reporting purposes)
        paper.setIssuer(issuer);

        // Add the paper to the list of all similar commercial papers in the ledger world state
        await ctx.ProjectList.addProject(paper);

        // Must return a serialized paper to caller of smart contract
        return paper;
    }


  
   

    // Query transactions

    /**
     * Query history of a commercial paper
     * @param {Context} ctx the transaction context
     * @param {String} issuer commercial paper issuer
     * @param {Integer} paperNumber paper number for this issuer
    */
    async queryHistory(ctx, issuer, paperNumber) {

        // Get a key to be used for History query

        let query = new QueryUtils(ctx, 'org.papernet.paper');
        let results = await query.getAssetHistory(issuer, paperNumber); // (cpKey);
        return results;

    }

    /**
    * queryOwner commercial paper: supply name of owning org, to find list of papers based on owner field
    * @param {Context} ctx the transaction context
    * @param {String} owner commercial paper owner
    */
    async queryOwner(ctx, owner) {

        let query = new QueryUtils(ctx, 'org.papernet.paper');
        let owner_results = await query.queryKeyByOwner(owner);

        return owner_results;
    }

    /**
    * queryPartial commercial paper - provide a prefix eg. "DigiBank" will list all papers _issued_ by DigiBank etc etc
    * @param {Context} ctx the transaction context
    * @param {String} prefix asset class prefix (added to ProjectList namespace) eg. org.papernet.paperMagnetoCorp asset listing: papers issued by MagnetoCorp.
    */
    async queryPartial(ctx, prefix) {

        let query = new QueryUtils(ctx, 'org.papernet.paper');
        let partial_results = await query.queryKeyByPartial(prefix);

        return partial_results;
    }

    /**
    * queryAdHoc commercial paper - supply a custom mango query
    * eg - as supplied as a param:     
    * ex1:  ["{\"selector\":{\"faceValue\":{\"$lt\":8000000}}}"]
    * ex2:  ["{\"selector\":{\"faceValue\":{\"$gt\":4999999}}}"]
    * 
    * @param {Context} ctx the transaction context
    * @param {String} queryString querystring
    */
    async queryAdhoc(ctx, queryString) {

        let query = new QueryUtils(ctx, 'org.papernet.paper');
        let querySelector = JSON.parse(queryString);
        let adhoc_results = await query.queryByAdhoc(querySelector);

        return adhoc_results;
    }


    /**
     * queryNamed - supply named query - 'case' statement chooses selector to build (pre-canned for demo purposes)
     * @param {Context} ctx the transaction context
     * @param {String} queryname the 'named' query (built here) - or - the adHoc query string, provided as a parameter
     */
    async queryNamed(ctx, queryname) {
        let querySelector = {};
        switch (queryname) {
            case "redeemed":
                querySelector = { "selector": { "currentState": 4 } };  // 4 = redeemd state
                break;
            case "trading":
                querySelector = { "selector": { "currentState": 3 } };  // 3 = trading state
                break;
            case "value":
                // may change to provide as a param - fixed value for now in this sample
                querySelector = { "selector": { "faceValue": { "$gt": 4000000 } } };  // to test, issue CommPapers with faceValue <= or => this figure.
                break;
            default: // else, unknown named query
                throw new Error('invalid named query supplied: ' + queryname + '- please try again ');
        }

        let query = new QueryUtils(ctx, 'org.papernet.paper');
        let adhoc_results = await query.queryByAdhoc(querySelector);

        return adhoc_results;
    }

}

module.exports = ProjectContract;
