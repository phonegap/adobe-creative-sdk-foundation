/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
*/

var exec = require('cordova/exec');

var AdobeCreativeSDKFoundation = {
    
    /*
    Logs in a user.
    
    The successCallback will be called if the login was successful, and it will return 
    as its only argument, a JSON object with these five keys:

        adobeID // The Adobe ID of the user
        displayName // The display name of the user
        firstName // The email address of the user
        lastName // The first name of the user
        email // The email address of the user
    
    The failureCallback will be called if the login was unsuccessful, and it will return
    as its only argument, an error message.
    */
    login: function(successCallback, failureCallback) {
        exec(successCallback, failureCallback, "AdobeCreativeSDKFoundation", "login", []);
    },

    /*
    Logs out a user.
    
    The successCallback will be called if the logout was successful, with no arguments.
    
    The failureCallback will be called if the logout was unsuccessful, and it will return
    as its only argument, an error message.
    */
    logout: function(successCallback, failureCallback) {
        exec(successCallback, failureCallback, "AdobeCreativeSDKFoundation", "logout", []);
    },
};

module.exports = AdobeCreativeSDKFoundation;
