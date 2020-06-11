pragma solidity ^0.5.0;




contract KYC_test {
    string private pname;	
    address creatorAdmin;
    	
    constructor() public {
        creatorAdmin = msg.sender;
        pname = "KYC Approval";
    }
    	
    enum Type { User, KYC_Admin, Bank_Admin }
	enum State { NotExist, Pending, Approved, Rejected }
	
	struct UserDetail {
		uint userId; // increment by one
		string userName;
		string homeAddress;
		State state;
		Type level;
		uint age;
		address createdBy; // change to approved by
		uint createdAt;
		string ipfsDoc;
	}
		
	struct AdminDetail {
		address adminAddress;
		uint adminId;
		State state;
		Type level;
		string adminName;
	}
		
	struct Bank {
		address bankAddress;
		uint bankId;
		State state;
		Type level;
		// address createdBy;
	}
    mapping (address => UserDetail) private userDetails;
    mapping (address => AdminDetail) private adminDetails;
    mapping (address => Bank) private bankDetails;
    // mapping (address => State) public submissionStatus;
	
	mapping (uint => address) private userIds;
	mapping (uint => address) private adminIds;
	mapping (uint => address) private bankIds;
	event RequestedNewAdmin(address  _newUser, uint256 _newUserId);
	event RequestedNewUser(address _newUser, uint256 _newUserId);
	event RequestedNewBank(address _newBank, uint256 _newBankId);
	event ApprovedUser(address _approvedUser);
	event ApprovedAdmin(address _approvedAdmin);
	event ApprovedBank(address _approvedBank);
	
	modifier onlyAdmins() {
	    //require(bankDetails[msg.sender].state == State.Approved);
		require(adminDetails[msg.sender].level == Type.KYC_Admin || creatorAdmin == msg.sender || bankDetails[msg.sender].state == State.Approved || userDetails[msg.sender].state != State.NotExist, "You’re not authorized to view");
		_;
	}
	
	// Check if the user has already not been registered.
	// This is to avoid repeated requests to add the same user.
	modifier notRegisteredUser(address _newUser, uint _newUserId) {
		require(userDetails[_newUser].state == State.NotExist);
		require(userIds[_newUserId] == address(0), "This user ID is already taken!");
		_;
	}
	/*
	// Request to add new Admin.
    function requestNewAdmin(address _newAdmin, uint _newAdminId,string memory _userName) onlyAdmins notRegisteredUser(_newAdmin, _newAdminId) private returns (bool success) {
		require(addNewAdmin(_newAdmin, _newAdminId, Type.KYC_Admin, _userName));
		emit RequestedNewAdmin(_newAdmin, _newAdminId);
		return true;
	}
	*/
	// Request to add new User.
	function requestNewUser(address _newUser, uint _newUserId,string memory _userName, string memory _homeAddress, uint _age, string memory _ipfsDoc)  notRegisteredUser(_newUser, _newUserId) public returns (bool success) {
		require(addNewUser(_newUser, _newUserId,Type.User, _userName, _homeAddress, _age, _ipfsDoc));
		emit RequestedNewUser(_newUser, _newUserId);
		return true;
	}
	// Common function to create entry in UserDetails Mapping.
	function addNewUser(address _userAddress, uint _userId, Type level,string memory _userName, string memory _homeAddress, uint _age, string memory _ipfsDoc) internal returns (bool success) {
	    require(_userAddress == msg.sender, "Wrong Address");
		userIds[_userId] = _userAddress;
		userDetails[_userAddress] = UserDetail(_userId, _userName, _homeAddress, State.Pending, level ,_age, msg.sender, now, _ipfsDoc);
		return true;
	}
	/*
	function addNewAdmin(address _adminAddress, uint _adminId, Type level,string memory _adminName) internal returns (bool success) {
		adminIds[_adminId] = _adminAddress;
		adminDetails[_adminAddress] = AdminDetail(_adminAddress, _adminId, State.Pending, level, _adminName);
		return true;
	}
	
	function approveAdmin(address _approvedAdmin)  public returns (bool success) {
	  require(userDetails[_approvedAdmin].level != Type.User, “This is not ADMIN submission”);
	  require(adminDetails[_approvedAdmin].adminAddress != msg.sender || creatorAdmin == msg.sender);
		adminDetails[_approvedAdmin].state = State.Approved;
		adminIds[adminDetails[_approvedAdmin].adminId] = _approvedAdmin;
		emit ApprovedAdmin(_approvedAdmin);
		return true;
	}
	*/
	function approveUser(address _approvedUser)  public returns (bool success) {
    	  require(userDetails[_approvedUser].createdBy != msg.sender || creatorAdmin == msg.sender);
		userDetails[_approvedUser].state = State.Approved;
		userIds[userDetails[_approvedUser].userId] = _approvedUser;
		emit ApprovedUser(_approvedUser);
		return true;
	}
	
    function approveBank(address _approvedBank)  public returns (bool success) {
          require(adminDetails[msg.sender].state == State.Approved || creatorAdmin == msg.sender);
    	  // require(bankDetails[_approvedBank].createdBy != msg.sender || creatorAdmin == msg.sender);
    		bankDetails[_approvedBank].state = State.Approved;
    		bankIds[bankDetails[_approvedBank].bankId] = _approvedBank;
    		emit ApprovedBank(_approvedBank);
    		return true;
    }
    function requestNewBank(address _newBankAddress, uint _newBankId)  notRegisteredUser (_newBankAddress, _newBankId) public returns (bool success) {
	 require(addNewBank(_newBankAddress, _newBankId, Type.Bank_Admin));
		emit RequestedNewBank(_newBankAddress, _newBankId);
		return true;
	}
	
	function addNewBank(address _bankAddress, uint _bankId, Type level) internal returns (bool success) {
	    require(_bankAddress == msg.sender, "Wrong Address");
		bankIds[_bankId] = _bankAddress;
		bankDetails[_bankAddress] = Bank( _bankAddress, _bankId, State.Pending, level);
		return true;
	}
	// Get the User Details.
	function getUserDetails(address _userAddress) onlyAdmins public view returns (uint userId, State state, Type level,string memory name, uint age, string memory homeAddress, string memory ipfsDoc) {
		UserDetail storage user = userDetails[_userAddress];
		return (user.userId, user.state, user.level, user.userName, user.age, user.homeAddress, user.ipfsDoc);
	}
	
	
	/*
	function getadminDetails(address _adminAddress) private view returns (address, uint, State, Type,string memory) {
		AdminDetail storage admin = adminDetails[_adminAddress];
		return (admin.adminAddress, admin.adminId, admin.state, admin.level, admin.adminName);
	}
	
}





