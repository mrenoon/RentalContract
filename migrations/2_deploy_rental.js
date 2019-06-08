const Rental = artifacts.require("Rental");

module.exports = function(deployer) {
  deployer.deploy(Rental,
    '0xE729401C300cc7140454deD05d6A487458c44018',
    '0x47cF4F8Db691F5fd25fEc1c89bfc5227473fabe5', //tenant
    '0x5131af5BD69a5067055a9fA4B250FCE7999efBFC', // landlord
    0,
    5 * 60, // 5 min
    4,
    200000000000000000,
    1 * 60, // 3 min deadline
    4 * 60, // max late 4 min
    3 * 60, // 3 min in advance
    300000000000000000 // deposit 0.3 eth
  );
};
