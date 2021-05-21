/*
 * Copyright IBM Corp. All Rights Reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { Contract } = require('fabric-contract-api');

class Health extends Contract {

    async initLedger(ctx) {
        await ctx.stub.putState('test','hello world')
        return "success"
    }

    async writeData(ctx,key,value) {
        await ctx.stub.putState(key,value)
        return value
    }
    async writeData(ctx,key) {
        var response=await ctx.stub.putState(key)
        return response.toString()
    }
    
}

module.exports = Health;
