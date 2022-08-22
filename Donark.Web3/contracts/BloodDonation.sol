pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract BloodDonation {
    //Some Public and private Variable
    address public owner;
    uint256 public activeDonarCounter = 0;
    uint256 public inactiveDonarCounter = 0;
    uint256 private donarCounter = 0;
    uint256 public activeRequestCounter = 0;
    uint256 public inactiveRequestCounter = 0;
    uint256 private RequestCounter = 0;

    //Constructor
    constructor() public {
        owner = msg.sender;
    }

    //mapsDonar
    mapping(uint256 => address) public donarOf;
    mapping(address => uint256) public donarPost;

    //MapOfRequest
    mapping(uint256 => address) public RequestOf;
    mapping(address => uint256) public RequestPost;

    //Enum
    enum Available {
        NO,
        YES
    }

    //DonarStruct
    struct DonarStruct {
        uint256 Id;
        string name;
        string age;
        string gender;
        string contactinformation;
        string location;
        string country;
        string city;
        string bloodGroup;
        uint256 requestId;
        address author;
        Available available;
        uint256 created;
        uint256 updated;
    }

    //RequestStruct
    struct RequestStruct {
        uint256 Id;
        string Name;
        string location;
        string contactInformation;
        string Country;
        string City;
        string BloodRequired;
        string Notes;
        Available available;
        address author;
        uint256 created;
        uint256 updated;
    }

    //activeDonars and inactiveDonar array
    DonarStruct[] activeDonars;
    DonarStruct[] inactiveDonars;
    RequestStruct[] allactiveRequest;
    RequestStruct[] allInactiveRequest;

    //Events
    event createRequest(
        uint256 postId,
        string actionType,
        Available available,
        address indexed executor,
        uint256 created
    );

    event UpdateRequestStatus(
        uint256 postId,
        address indexed executor,
        uint256 created
    );

    //Events
    event Action(
        uint256 postId,
        string actionType,
        Available available,
        address indexed executor,
        uint256 created
    );

    //Update Donar Value
    event UpdateDonarValue(
        uint256 postId,
        address indexed executor,
        uint256 created
    );

    //Update Donar Status
    event UpdateDonarStatus(
        uint256 postId,
        address indexed executor,
        uint256 created
    );

    event UpdateDonarRequestId(
        uint256 postId,
        address indexed executor,
        uint256 created
    );

    //Modifier
    modifier ownerOnly() {
        require(msg.sender == owner, "Owner reserved only");
        _;
    }

    function getLastUserPostId() external view returns (uint256) {
        uint256 results;
        results = donarPost[msg.sender];
        return results;
    }

    //create Donar
    function createDonar(string[] calldata data) external returns (bool) {
        require(bytes(data[0]).length > 0, "name cannot be empty");
        require(bytes(data[1]).length > 0, "age cannot be empty");
        require(bytes(data[2]).length > 0, "gender cannot be empty");
        require(
            bytes(data[3]).length > 0,
            "conatactInforamtion cannot be empty"
        );
        require(bytes(data[4]).length > 0, "location cannot be empty");
        require(bytes(data[5]).length > 0, "country cannot be empty");
        require(bytes(data[6]).length > 0, "city cannot be empty");
        require(
            bytes(data[7]).length > 0,
            "BloodGroup information cannot be empty"
        );

        donarCounter++;
        donarOf[donarCounter] = msg.sender;
        donarPost[msg.sender]++;
        activeDonarCounter++;

        activeDonars.push(
            DonarStruct(
                donarCounter,
                data[0],
                data[1],
                data[2],
                data[3],
                data[4],
                data[5],
                data[6],
                data[7],
                0,
                msg.sender,
                Available.YES,
                block.timestamp,
                block.timestamp
            )
        );

        emit Action(
            donarCounter,
            "Donar CREATED",
            Available.YES,
            msg.sender,
            block.timestamp
        );

        return true;
    }

    //update Donar Status
    function updateDonarStatus(uint256 Id) external returns (bool) {
        require(donarOf[Id] == msg.sender, "Unauthorized entity");
        for (uint256 i = 0; i < activeDonars.length; i++) {
            if (activeDonars[i].Id == Id) {
                activeDonars[i].available = Available.NO;
                activeDonars[i].updated = block.timestamp;
                inactiveDonars.push(activeDonars[i]);
                delete activeDonars[i];
                delete donarOf[i];
            } else {
                return false;
            }
        }
        donarPost[msg.sender]--;
        activeDonarCounter--;
        inactiveDonarCounter++;
        emit UpdateDonarStatus(Id, msg.sender, block.timestamp);
        return true;
    }

    //create Donar with RequestId
    function updateDonarRequestStatus(string[] calldata data, uint256 RequestId)
        external
        returns (bool)
    {
        require(bytes(data[0]).length > 0, "name cannot be empty");
        require(bytes(data[1]).length > 0, "age cannot be empty");
        require(bytes(data[2]).length > 0, "gender cannot be empty");
        require(
            bytes(data[3]).length > 0,
            "conatactInforamtion cannot be empty"
        );
        require(bytes(data[4]).length > 0, "location cannot be empty");
        require(bytes(data[5]).length > 0, "country cannot be empty");
        require(bytes(data[6]).length > 0, "city cannot be empty");
        require(
            bytes(data[7]).length > 0,
            "BloodGroup information cannot be empty"
        );

        donarCounter++;
        donarOf[donarCounter] = msg.sender;
        donarPost[msg.sender]++;
        activeDonarCounter++;

        activeDonars.push(
            DonarStruct(
                donarCounter,
                data[0],
                data[1],
                data[2],
                data[3],
                data[4],
                data[5],
                data[6],
                data[7],
                RequestId,
                msg.sender,
                Available.YES,
                block.timestamp,
                block.timestamp
            )
        );

        emit Action(
            donarCounter,
            "Donar CREATED wiht RequestId",
            Available.YES,
            msg.sender,
            block.timestamp
        );

        return true;
    }

    //Get All ActiveDonars
    function getAllActiveDonars() external view returns (DonarStruct[] memory) {
        return activeDonars;
    }

    //Get All UserActiveDonar
    function getAllUserActiveDonars()
        external
        view
        returns (DonarStruct[] memory)
    {
        uint256 resultCount;
        for (uint256 i = 0; i < activeDonars.length; i++) {
            if (activeDonars[i].author == msg.sender) {
                resultCount++;
            }
        }
        DonarStruct[] memory results = new DonarStruct[](resultCount);
        uint256 j;

        for (uint256 i = 0; i < activeDonars.length; i++) {
            if (activeDonars[i].author == msg.sender) {
                results[j] = activeDonars[i];
                j++;
            }
        }

        return results;
    }

    //CreateDonarRequest
    function createBloodRequest(string[] calldata data)
        external
        returns (bool)
    {
        require(bytes(data[0]).length > 0, "name cannot be empty");
        require(bytes(data[1]).length > 0, "location cannot be empty");
        require(
            bytes(data[2]).length > 0,
            "contactInformation cannot be empty"
        );
        require(bytes(data[3]).length > 0, "country cannot be empty");
        require(bytes(data[4]).length > 0, "city cannot be empty");
        require(bytes(data[5]).length > 0, "BloodGroup cannot be empty");
        require(bytes(data[6]).length > 0, "Notes cannot be empty");

        RequestCounter++;
        RequestOf[RequestCounter] = msg.sender;
        RequestPost[msg.sender]++;
        activeRequestCounter++;

        allactiveRequest.push(
            RequestStruct(
                RequestCounter,
                data[0],
                data[1],
                data[2],
                data[3],
                data[4],
                data[5],
                data[6],
                Available.NO,
                msg.sender,
                block.timestamp,
                block.timestamp
            )
        );

        emit createRequest(
            RequestCounter,
            "Donar CREATED",
            Available.NO,
            msg.sender,
            block.timestamp
        );

        return true;
    }

    function updateRequestStatus(uint256 Id) external returns (bool) {
        require(RequestOf[Id] == msg.sender, "Unauthorized entity");
        for (uint256 i = 0; i < allactiveRequest.length; i++) {
            if (allactiveRequest[i].Id == Id) {
                allactiveRequest[i].available = Available.YES;
                allactiveRequest[i].updated = block.timestamp;
                allInactiveRequest.push(allactiveRequest[i]);
                delete allactiveRequest[i];
                delete RequestOf[i];
            } else {
                return false;
            }
        }
        RequestPost[msg.sender]--;
        activeRequestCounter--;
        inactiveRequestCounter++;
        emit UpdateRequestStatus(Id, msg.sender, block.timestamp);
        return true;
    }

    function getAllBloodRequest()
        external
        view
        returns (RequestStruct[] memory)
    {
        return allactiveRequest;
    }

    function getAllUserRequest()
        external
        view
        returns (RequestStruct[] memory)
    {
        uint256 resultCount;
        for (uint256 i = 0; i < allactiveRequest.length; i++) {
            if (allactiveRequest[i].author == msg.sender) {
                resultCount++;
            }
        }
        RequestStruct[] memory results = new RequestStruct[](resultCount);
        uint256 j;

        for (uint256 i = 0; i < allactiveRequest.length; i++) {
            if (allactiveRequest[i].author == msg.sender) {
                results[j] = allactiveRequest[i];
                j++;
            }
        }

        return results;
    }
}
