// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Simple Reputation / Achievement Tracker
/// @notice Tracks user points and badges on-chain.
/// @dev Great for gamified dApps, DAOs, or community reward systems.

contract ReputationTracker {
    address public owner;

    struct UserProfile {
        uint points;
        string[] badges;
    }

    // Mapping from user address to their profile
    mapping(address => UserProfile) private profiles;

    // Events
    event PointsAdded(address indexed user, uint points, uint totalPoints);
    event PointsRemoved(address indexed user, uint points, uint totalPoints);
    event BadgeAwarded(address indexed user, string badge);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Transfer contract ownership to another address
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /// @notice Add points to a user’s profile
    function addPoints(address user, uint points) external onlyOwner {
        require(points > 0, "Points must be greater than 0");
        profiles[user].points += points;
        emit PointsAdded(user, points, profiles[user].points);
    }

    /// @notice Remove points from a user’s profile
    function removePoints(address user, uint points) external onlyOwner {
        require(points > 0, "Points must be greater than 0");
        require(profiles[user].points >= points, "Not enough points to remove");
        profiles[user].points -= points;
        emit PointsRemoved(user, points, profiles[user].points);
    }

    /// @notice Award a badge to a user
    function awardBadge(address user, string calldata badgeName) external onlyOwner {
        require(bytes(badgeName).length > 0, "Badge name required");
        profiles[user].badges.push(badgeName);
        emit BadgeAwarded(user, badgeName);
    }

    /// @notice Get a user’s total points
    function getPoints(address user) external view returns (uint) {
        return profiles[user].points;
    }

    /// @notice Get all badges a user has earned
    function getBadges(address user) external view returns (string[] memory) {
        return profiles[user].badges;
    }
}
