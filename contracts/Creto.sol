// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Creto {
    struct Certificate {
        string hash;
        string name;
        uint256 timestamp;
        address owner;
        address creator;
        uint8 royalty;
        string verificationProof;
    }

    mapping(string => Certificate) public certificates;
    mapping(string => uint256) public documentPrices;
    uint256 public totalCertificates;

    event CertificateIssued(
        string indexed hash,
        string name,
        address owner,
        uint256 timestamp,
        string verificationProof
    );

    event PriceUpdated(string indexed hash, uint256 newPrice);

    function issueCertificate(
        string memory _hash,
        string memory _name,
        uint8 _royalty,
        string memory _verificationProof
    ) external {
        require(bytes(_hash).length > 0, "IPFS hash required");
        require(bytes(_name).length > 0, "Document name required");
        require(_royalty <= 100, "Royalty cannot exceed 100%");
        require(bytes(certificates[_hash].hash).length == 0, "Certificate exists");
        
        certificates[_hash] = Certificate({
            hash: _hash,
            name: _name,
            timestamp: block.timestamp,
            owner: msg.sender,
            creator: msg.sender,
            royalty: _royalty,
            verificationProof: _verificationProof
        });

        documentPrices[_hash] = 0; // Initialize price
        totalCertificates++;
        
        emit CertificateIssued(_hash, _name, msg.sender, block.timestamp, _verificationProof);
    }

    function updatePrice(string memory _hash, uint256 _newPrice) external {
        require(msg.sender == certificates[_hash].owner, "Only owner can update");
        documentPrices[_hash] = _newPrice;
        emit PriceUpdated(_hash, _newPrice);
    }

    function getCertificate(string memory _hash) external view returns (Certificate memory) {
        return certificates[_hash];
    }

    function getPrice(string memory _hash) external view returns (uint256) {
        return documentPrices[_hash];
    }
}