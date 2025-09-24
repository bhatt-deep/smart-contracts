# Smart Contracts Repository

This repository contains a collection of Solidity smart contracts created during my early blockchain development journey.
The contracts showcase different patterns and concepts in Ethereum smart contract programming.

## Contents

### 1. Auction Smart Contract

A basic English auction contract with:

* Bidding system (highest bidder wins).
* Auction lifecycle (start, end, cancel).
* Withdrawals for non-winning bidders.

**Use Case:** Demonstrates how value exchange and auctions can be managed on-chain.

---

### 2. ERC20 Tokens

A simple ERC20 implementation including:

* Token transfers (`transfer`, `approve`, `transferFrom`).
* Balances and allowances.
* Standard events (`Transfer`, `Approval`).

**Use Case:** Foundation for fungible tokens such as utility or governance tokens.

---

### 3. Greeter.sol

A small example contract for:

* Storing and updating a greeting message.
* Demonstrating state variables and access control.

**Use Case:** “Hello World” for Solidity — useful for testing deployments.

---

### 4. RBAC (Role-Based Access Control)

Two versions exploring role-based permissions:

* **RBAC.sol** → Basic demonstration of restricting functions to specific roles.
* **RBAC-2b.sol** → Slightly extended functionality for token control.

**Use Case:** Shows how smart contracts can implement admin and user roles.

---

## 🔧 Tech Stack

* **Language**: Solidity ^0.6.x
* **Patterns Covered**: ERC20, Auction mechanism, Access Control, Simple utilities
