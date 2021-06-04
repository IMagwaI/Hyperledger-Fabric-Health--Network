
'use strict';

// Utility class for ledger state
const State = require('../ledger-api/state.js.js.js.js');

// Enumerate projet paper state values
const pState = {
    P_IDENTIFIED: 1,
    HM_STUDIED: 2,
    HM_IDENTIFIED: 3,
    P_VALIDATED: 4,
    HM_ESTIMATED:5,
    FM_STUDIED:6,
    P_MONITORING:7
};

/**
 * Projet class extends State class
 * Class will be used by application and smart contract to define a paper
 */
class Projet extends State {

    constructor(obj) {
        super(Projet.getClass(), [obj.issuer, obj.Number]);
        Object.assign(this, obj);
    }

    /**
     * Basic getters and setters
    */ 
    getIssuer() {
        return this.issuer;
    }

    setIssuer(newIssuer) {
        this.issuer = newIssuer;
    }



    setIssuerMSP(mspid) {
        this.mspid = mspid;
    }

    getIssuerMSP() {
        return this.mspid;
    }



    /**
     * Useful methods to encapsulate commercial paper states
     */
    setP_IDENTIFIED() {
        this.currentState = pState.P_IDENTIFIED;
    }
    setHM_STUDIED() {
        this.currentState = pState.HM_STUDIED;
    }
    setHM_IDENTIFIED() {
        this.currentState = pState.HM_IDENTIFIED;
    }
    setP_VALIDATED() {
        this.currentState = pState.P_VALIDATED;
    }
    setHM_ESTIMATED() {
        this.currentState = pState.HM_ESTIMATED;
    }
    setFM_STUDIED() {
        this.currentState = pState.FM_STUDIED;
    }
    setP_MONITORING() {
        this.currentState = pState.P_MONITORING;
    }

    isP_IDENTIFIED() {
        return this.currentState === pState.P_IDENTIFIED;
    }

    isHM_STUDIED() {
        return this.currentState === pState.HM_STUDIED;
    }

    isHM_IDENTIFIED() {
        return this.currentState === pState.HM_IDENTIFIED;
    }

    isP_VALIDATED() {
        return this.currentState === pState.P_VALIDATED;
    }

    isHM_ESTIMATED() {
        return this.currentState === pState.HM_ESTIMATED;
    }
  
    isFM_STUDIED() {
        return this.currentState === pState.FM_STUDIED;
    }

    isP_MONITORING() {
        return this.currentState === pState.P_MONITORING;
    }


    static fromBuffer(buffer) {
        return Projet.deserialize(buffer);
    }

    toBuffer() {
        return Buffer.from(JSON.stringify(this));
    }

    /**
     * Deserialize a state data to commercial paper
     * @param {Buffer} data to form back into the object
     */
    static deserialize(data) {
        return State.deserializeClass(data, Projet);
    }

    /**
     * Factory method to create a commercial paper object
     */
    static createInstance(issuer, paperNumber, issueDateTime, maturityDateTime, faceValue) {
        return new Projet({ issuer, paperNumber, issueDateTime, maturityDateTime, faceValue });
    }

    static getClass() {
        return 'org.healthnet.Projet';
    }
}

module.exports = Projet;
