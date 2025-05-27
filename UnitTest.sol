// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "./Person_part2.sol";

contract UnitTest {
    Person public p1;
    Person public p2;

    constructor() {
        // Deploy two Person contracts with dummy parents
        p1 = new Person(address(0x1), address(0x2), 60);
        //p2 = new Person(address(0x3), address(0x4), 18);

        //p1Marry(); 
    }

    function p1Birthday() public {
        p1.haveBirthday();
    }

    //function p2Birthday() public {
    //   p2.haveBirthday();
    //}

    function p1Marry(address a) public {
        p1.marry(a); 
    }

    //function p2Marry() public {
    //    p2.marry(address(p1)); 
   // }

    function p1Divorce() public {
        p1.divorce();  
    }

    //function p2Divorce() public {
    //    p2.divorce();
    //}

    // ~~~~ Echidna invariants ~~~~

    function echidna_reciprocal_marriage() public view returns (bool) {
        if (p1.getSpouse() != address(0)) {
            return Person(p1.getSpouse()).getSpouse() == address(p1);
        }
        else return true;
    }

    function echidna_adult_marriage() public view returns (bool) {
        if (p1.getSpouse() != address(0)) {
            return p1.getAge() >= 18 && Person(p1.getSpouse()).getAge() >= 18;
        }
        else return true;
    }

    function echidna_no_sibling_marriage() public view returns (bool) {
        if (p1.getSpouse() != address(0)) {
            return p1.getMother() != Person(p1.getSpouse()).getMother();
        }
        else return true;
    } 
    }