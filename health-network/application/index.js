/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Fabric smart contract classes
const { Contract, Context } = require('fabric-contract-api');

// HealthNet specifc classes
const Project = require('./contract/project.js');
const ProjectList = require('./contract/projectlist.js');
const QueryUtils = require('./queries.js');

/**
 * A custom context provides easy access to list of all projects
 */
class ProjectContext extends Context {

    constructor() {
        super();
        // All papers are held in a list of papers
        this.ProjectList = new ProjectList(this);
    }

}

/**
 * Define project smart contract by extending Fabric Contract class
 *
 */
class ProjectContract extends Contract {

    /**
     * Define a custom context 
    */
    createContext() {
        return new ProjectContext();
    }


    async instantiate(ctx) {
        console.log('Instantiate the contract');
    }


    async issue(ctx, issuer, projectNumber) {
        let project = Project.createInstance(issuer, projectNumber);

        project.setIssued();
        let mspid = ctx.clientIdentity.getMSPID();
        project.setIssuerMSP(mspid);
        project.setIssuer(issuer);
        await ctx.ProjectList.addProject(project);
        return project;
    }

    async studyingByHealthMinistry(ctx, issuer, projectNumber) {
        let projectKey = Project.makeKey([issuer, projectNumber]);
        let project = await ctx.ProjectList.getProject(projectKey);
        console.log(project.toString())

        return project;
    }




    async queryHistory(ctx, issuer, projectNumber) {

        // Get a key to be used for History query
        
        let query = new QueryUtils(ctx, 'org.healthnet.Project');
        let results = await query.getAssetHistory(issuer, projectNumber); // (cpKey);
        return results;

    }


}

module.exports = ProjectContract;
