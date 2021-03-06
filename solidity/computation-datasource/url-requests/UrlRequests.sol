pragma solidity >= 0.5.0 < 0.6.0;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract UrlRequests is usingOraclize {

    event LogNewOraclizeQuery(string description);
    event LogResult(string result);

    constructor()
        public
    {
        oraclize_setProof(proofType_Android | proofStorage_IPFS);
    }

    function __callback(
        bytes32 _myid,
        string memory _result,
        bytes memory _proof
    )
        public
    {
        require(msg.sender == oraclize_cbAddress());
        emit LogResult(_result);
    }

    function request(
        string memory _query,
        string memory _method,
        string memory _url,
        string memory _kwargs
    )
        public
        payable
    {
        if (oraclize_getPrice("computation") > address(this).balance) {
            emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer...");
            oraclize_query("computation",
                [_query,
                _method,
                _url,
                _kwargs]
            );
        }
    }
    /**
     * @dev Sends a custom content-type in header and returns the header used
     * as result. Wrap first argument of computation ds with helper needed,
     * such as json in this case
     */
    function requestCustomHeaders()
        public
        payable
    {
        request("json(QmdKK319Veha83h6AYgQqhx9YRsJ9MJE7y33oCXyZ4MqHE).headers",
                "GET",
                "http://httpbin.org/headers",
                "{'headers': {'content-type': 'json'}}"
                );
    }

    function requestBasicAuth()
        public
        payable
    {
        request("QmdKK319Veha83h6AYgQqhx9YRsJ9MJE7y33oCXyZ4MqHE",
                "GET",
                "http://httpbin.org/basic-auth/myuser/secretpass",
                "{'auth': ('myuser','secretpass'), 'headers': {'content-type': 'json'}}"
                );
    }

    function requestPost()
        public
        payable
    {
        request("QmdKK319Veha83h6AYgQqhx9YRsJ9MJE7y33oCXyZ4MqHE",
                "POST",
                "https://api.postcodes.io/postcodes",
                '{"json": {"postcodes" : ["OX49 5NU"]}}'
                );
    }

    function requestPut()
        public
        payable
    {
        request("QmdKK319Veha83h6AYgQqhx9YRsJ9MJE7y33oCXyZ4MqHE",
                "PUT",
                "http://httpbin.org/anything",
                "{'json' : {'testing':'it works'}}"
                );
    }

    function requestCookies()
        public
        payable
    {
        request("QmdKK319Veha83h6AYgQqhx9YRsJ9MJE7y33oCXyZ4MqHE",
                "GET",
                "http://httpbin.org/cookies",
                "{'cookies' : {'thiscookie':'should be saved and visible :)'}}"
                );
    }
}
