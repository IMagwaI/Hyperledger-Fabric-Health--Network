/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for collections of ledger states --  a state list
const StateList = require('../ledger-api/statelist.js.js.js.js');

const Project = require('./project.js');

class ProjectList extends StateList {

    constructor(ctx) {
        super(ctx, 'org.healthnet.paper');
        this.use(Project);
    }

    async addProject(paper) {
        return this.addState(paper);
    }

    async getProject(paperKey) {
        return this.getState(paperKey);
    }

    async updateProject(paper) {
        return this.updateState(paper);
    }
}


module.exports = ProjectList;
