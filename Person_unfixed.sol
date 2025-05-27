pragma solidity ^0.8.22;
// SPDX-License-Identifier: UNLICENSED

contract Person {

 uint age; 

 bool isMarried; 

 /* Reference to spouse if person is married, address(0) otherwise */
 address spouse; 


address  mother; 
address  father; 

 uint constant  DEFAULT_SUBSIDY = 500;

 /* welfare subsidy */
 uint state_subsidy;


 constructor() { // address ma, address fa) {
   age = 0;
   isMarried = false;
   mother = address(0x1);//ma;
   father = address(0x2);//fa;
   spouse = address(0);
   state_subsidy = DEFAULT_SUBSIDY;
 } 


 //We require new_spouse != address(0);
 function marry(address new_spouse) public {
  spouse = new_spouse;
  isMarried = true;
 }
 
 function divorce() public {
  Person sp = Person(address(spouse));
  sp.setSpouse(address(0));
  spouse = address(0);
  isMarried = false;
 }

 function haveBirthday() public {
  age++;
 }

function setSpouse(address sp) public {
    spouse = sp;
}
// turned into view
function getSpouse() public view returns (address) {
    return spouse;
}

// added 
function getAge() public view returns (uint) {
  return age;
}

// added
function getMother() public view returns (address) {
  return mother;
}

/* ~~~~ Echidna invariants ~~~~ */
  function echidna_isMarried_consistency() public view returns (bool) {
    return isMarried == (spouse != address(0));
  }

  function echidna_no_self_marriage() public view returns (bool) {
    return spouse != address(this);
  }

  function echidna_no_mother_marriage() public view returns (bool) {
    return spouse != mother;
  } 

  function echidna_no_father_marriage() public view returns (bool) {
    return spouse != father;
  } 
}
