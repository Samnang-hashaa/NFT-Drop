// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IAllowlist {
    function allowlistedAddresses(address) external view returns (bool);
}