/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
*/

'use strict';

// Utility class for collections of ledger states --  a state list
const StateList = require('../ledger-api/statelist.js');

const Project = require('./project.js');

class ProjectList extends StateList {

    constructor(ctx) {
        super(ctx, 'org.healthnet.paper');
        this.use(Project);
        this.ctx = ctx;

    }

     async addProject(project) {
        console.log(project)
        return this.addState(project);

        // var response=await this.ctx.stub.putState(project.getNumber(),project)
        // return response.toString();

    }

    async getProject(projectKey) {
        return this.getState(projectKey);

        // let data = await this.ctx.stub.getState(projectKey);
        // return data;
    }

    async updateProject(project) {
        return this.updateState(project);

        // var response=await this.ctx.stub.putState(project.getNumber(),project)
        // return response.toString();
    }
}


module.exports = ProjectList;
