// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/grpc;
import ballerina/lang.runtime as runtime;

listener grpc:Listener ep10 = new (9100,
    host = "localhost",
    secureSocket = {
    key: {
        path: KEYSTORE_PATH,
        password: "ballerina"
    },
    mutualSsl: {
        verifyClient: grpc:REQUIRE,
        cert: {
            path: TRUSTSTORE_PATH,
            password: "ballerina"
        }
    },
    protocol: {
        name: grpc:TLS,
        versions: ["TLSv1.2", "TLSv1.1"]
    },
    ciphers: ["TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"]
});

@grpc:Descriptor {
    value: GRPC_SSL_SERVER_DESC
}
service "GrpcMutualSslService" on ep10 {
    isolated remote function hello(GrpcMutualSslServiceStringCaller caller, string name) {
        string message = "Hello " + name;
        runtime:sleep(2);
        checkpanic caller->sendString(message);
        checkpanic caller->complete();
    }
}
