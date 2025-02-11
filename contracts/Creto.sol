// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Creto {
    struct Ownership {
        address ownerAddress;
        uint256 datePurchased;
    }

    struct Document {
        string documentHash; // Hash of the document
        string documentName;
        uint256 timestamp; // Real-world timestamp
        address owner;
    }

    mapping(string => Document) public documents;
    mapping(string => Ownership[]) public ownershipRecords;

    event DocumentUploaded(string documentHash, string documentName, address owner, uint256 timestamp);

    function uploadDocument(string memory documentHash, string memory documentName) public {
        require(bytes(documents[documentHash].documentHash).length == 0, "Document already exists");

        documents[documentHash] = Document(documentHash, documentName, block.timestamp, msg.sender);
        ownershipRecords[documentHash].push(Ownership(msg.sender, block.timestamp));

        emit DocumentUploaded(documentHash, documentName, msg.sender, block.timestamp);
    }

    function getDocumentDetails(string memory documentHash) public view returns (string memory, string memory, uint256, address) {
        require(bytes(documents[documentHash].documentHash).length != 0, "Document not found");
        
        Document memory doc = documents[documentHash];
        return (doc.documentHash, doc.documentName, doc.timestamp, doc.owner);
    }

    function transferDocumentOwnership(string memory documentHash, address newOwner) public {
        require(documents[documentHash].owner == msg.sender, "Only the owner can transfer");
        
        documents[documentHash].owner = newOwner;
        ownershipRecords[documentHash].push(Ownership(newOwner, block.timestamp));
    }
}
