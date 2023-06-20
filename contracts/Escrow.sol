// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function transferFrom(address _from, address _to, uint256 id) external;
}

contract Escrow {
    address public nftAddress; 
    address payable public seller;
    address public inspector;
    address public lender;

    mapping(uint256 => bool) public isListed;
    mapping(uint256 => uint256) public purchasePrice;
    mapping(uint256 => uint256) public escrowAmount;
    mapping(uint256 => address) public buyer;
    mapping(uint256 => bool) public inspectionPassed;
    mapping(uint256 => mapping(address => bool)) public approval;

 modifier onlyBuyer(uint256 _nftId ) {
        require(msg.sender == buyer[_nftId], "Only Buyer can call this method");
        _;
    }
    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this method");
        _;
    }
     modifier onlyInspector() {
        require(msg.sender == inspector, "Only inspector can call this method");
        _;
    }
 
    constructor(address _nftAddress, address payable _seller, address _inspector, address _lender) {
        nftAddress = _nftAddress;
        seller = _seller;
        inspector = _inspector;
        lender = _lender;
    }
    function list(uint256 _nftID, address _buyer, uint256 _purchasePrice, uint256 _escrowAmount) public payable onlySeller {
        IERC721(nftAddress).transferFrom(msg.sender, address(this), _nftID);
        isListed[_nftID] = true;
        purchasePrice[_nftID] = _purchasePrice;
        escrowAmount[_nftID] = _escrowAmount;
        buyer[_nftID] = _buyer; 
    }
    function depositeEarnet(uint256 _nftID) public payable onlyBuyer(_nftID){
        require(msg.value >= escrowAmount[_nftID], "invalid amount");
    } 
     function updateInspectionStatus(uint256 _nftID, bool _passed)
        public
        onlyInspector
    {
        inspectionPassed[_nftID] = _passed;
    }
    function approveSale(uint256 _nftID) public {
        require(_nftID != 0, "Invalid Id");
        if (isListed[_nftID]){
            approval[_nftID][msg.sender]=true;
        }
    }
    function finalizeSale(uint256 _nftID) public {
        require(!inspectionPassed[_nftID],"Already passed for Inspection");
        require(approval[ _nftID ][buyer[_nftID]],"Not approved by the Seller");
        require(approval[_nftID][seller]);
        require(approval[_nftID][lender]);
        require(address(this).balance >= purchasePrice[_nftID]);
        isListed[_nftID] = false;
        (bool success, ) = payable(seller).call{value: address(this).balance}("");
        require(success);
        // Transfer NFT to new Owner and Escrow Amount back to Lender  
         IERC721(nftAddress).transferFrom(address(this), buyer[_nftID], _nftID);
    }
}