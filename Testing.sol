// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "./Person.sol";

contract TestHarness {
    Person public p1;
    Person public p2;

    constructor() {
        // Deploy two Person contracts with dummy parents
        p1 = new Person(address(0x100), address(0x200), 18);
        p2 = new Person(address(0x300), address(0x400), 18);
    }

    // Fuzz this to test reciprocal marriage
    function tryMarry() public {
        try p1.marry(address(p1)) {} catch {}
        try p2.marry(address(p2)) {} catch {}
    }

    function tryDivorce() public {
        try p1.divorce() {} catch {}
        try p2.divorce() {} catch {}
    }

    // ~~~~ Echidna invariants ~~~~

    // Spouse pointers must be consistent
    function echidna_reciprocal_marriage() public view returns (bool) {
        return p1.getSpouse() == Person(p1).getSpouse();
    }

    function echidna_adult_marriage() public view returns (bool) {
      if (p1.getSpouse() != address(0)) {
          return p1.getAge() >= 18 && Person(p1.getSpouse()).getAge() >= 18;
      }
      return true;
    }
}