textwidthpragma solidity ^0.8.22;
// SPDX-License-Identifier: UNLICENSED

contract Person {
  uint8 internal age; // made internal
  bool isMarried; 

  /* Reference to spouse if person is married, address(0) otherwise */
  address internal spouse;  // made internal 
  address immutable mother; // made immutable  
  address immutable father; // made immutable

  /* welfare subsidy */
  uint constant DEFAULT_SUBSIDY = 500;
  uint state_subsidy;

  // Echidna requires a constructor without input arguments.
  // added uint8 _age
  constructor() { //(address ma, address fa, uint8 _age) {
    //require(ma != address(0), "Please specify a non-zero mother address."); // added 
    //require(fa != address(0), "Please specify a non-zero father address."); // added 
    //require(ma != fa, "Mother and father must be different people."); // added 
    //require(_age <= 120, "Please provide an age lower than 121."); 

    age = 18;//_age;
    mother = address(0x1);//ma;
    father = address(0x2);//fa;
    spouse = address(0);
    isMarried = false;
    state_subsidy = DEFAULT_SUBSIDY;
  } 

  function marry(address new_spouse) public {
    // single costraints
    require(new_spouse != address(0), "Please specify a non-zero spouse."); // added 
    require(new_spouse != address(this), "You cannot marry yourself."); // added
    require(new_spouse != mother, "You cannot marry your own mother."); // added
    require(new_spouse != father, "You cannot marry your own father."); // added
    require(spouse == address(0), "You are already married."); // added
    require(age >= 18, "You must be at least 18 years old to get married."); // added 

    // significant other costraints
    Person other = Person(new_spouse);
    require(other.getMother() != mother, "You cannot marry a sibling."); // added
    require(other.getAge() >= 18, "Your spouse must be at least 18 years old to get married."); // added 
    require(other.getSpouse() == address(0), "The other person is already married with someone else."); // added

    // actually marry 
    spouse = new_spouse;
    other.acceptMarriage(address(this));
    isMarried = true;
  }

  function divorce() public {
    require(spouse != address(0), "You are not currently married."); // added 

    // actually divorce 
    address temp = spouse;  
    spouse = address(0);
    Person(temp).acceptDivorce(address(this)); // added 
    isMarried = false;
  }

  function haveBirthday() public {
    require(age < 120, "Cannot increase age any further than 120."); // added

    age++;
  }

  // added 
  // requires the significant other to already have set spouse = address(this)
  function acceptMarriage(address sp) public {
    require(Person(sp).getSpouse() == address(this), "The other part must have accepted to marry you."); // added
    require(isMarried == false, "You are already married to this person.");
    
    spouse = sp;
    isMarried = true;
  }

  // added 
  // requires the significant other to already have set spouse = address(0)
  function acceptDivorce(address sp) public {
    require(spouse == sp, "You cannot divorce someone you are not married with.");
    require(Person(sp).getSpouse() == address(0), "The other part must have accepted to divorce you."); // added

    spouse = address(0);
    isMarried = false;
  }

  // removed
  //function setSpouse(address sp) public {
  //  spouse = sp;
  //}

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