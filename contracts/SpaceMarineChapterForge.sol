// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

/// @title Space Marine Chapter Forge
/// @notice Users create custom Space Marine chapters; others can vote like/dislike.
/// @dev Pure text-only contract. No funds, no owner, no external calls.
contract SpaceMarineChapterForge {

    uint256 public constant MAX_TEXT_SIZE = 2000;

    struct Chapter {
        string name;            // Chapter name
        string geneFather;      // Primarch / genetic progenitor
        string history;         // Chapter history / lore
        string heroicDeeds;     // Notable heroic deeds
        string motto;           // Official motto
        address creator;        // Who created the chapter
        uint256 createdAt;      // Timestamp
        uint256 likes;          // Number of positive votes
        uint256 dislikes;       // Number of negative votes
    }

    // chapterId => voter => true/false (has voted)
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    // chapterId => voter => true if like, false if dislike
    mapping(uint256 => mapping(address => bool)) public voteIsLike;

    Chapter[] public chapters;

    event ChapterCreated(
        uint256 indexed chapterId,
        string name,
        string geneFather,
        address indexed creator
    );

    event ChapterVoted(
        uint256 indexed chapterId,
        address indexed voter,
        bool like,
        uint256 newLikes,
        uint256 newDislikes
    );

    /// @notice Constructor creates chapter 0 as an example.
    constructor() {
        chapters.push(
            Chapter({
                name: "Example Chapter",
                geneFather: "Unknown Primarch",
                history: "This is a placeholder chapter used as ID 0.",
                heroicDeeds: "None. This entry exists only to reserve index 0.",
                motto: "For Demonstration Only",
                creator: address(0),
                createdAt: block.timestamp,
                likes: 0,
                dislikes: 0
            })
        );
    }

    /// @notice Create a new Space Marine chapter with full lore.
    function createChapter(
        string calldata name,
        string calldata geneFather,
        string calldata history,
        string calldata heroicDeeds,
        string calldata motto
    ) external {
        require(bytes(name).length > 0, "Name required");
        require(bytes(name).length <= MAX_TEXT_SIZE, "Name too large");
        require(bytes(geneFather).length <= MAX_TEXT_SIZE, "GeneFather too large");
        require(bytes(history).length <= MAX_TEXT_SIZE, "History too large");
        require(bytes(heroicDeeds).length <= MAX_TEXT_SIZE, "Heroic deeds too large");
        require(bytes(motto).length <= MAX_TEXT_SIZE, "Motto too large");

        Chapter memory c = Chapter({
            name: name,
            geneFather: geneFather,
            history: history,
            heroicDeeds: heroicDeeds,
            motto: motto,
            creator: msg.sender,
            createdAt: block.timestamp,
            likes: 0,
            dislikes: 0
        });

        chapters.push(c);
        uint256 id = chapters.length - 1; // starts at 1 because 0 is example

        emit ChapterCreated(id, name, geneFather, msg.sender);
    }

    /// @notice Vote like or dislike on a chapter. One vote per address per chapter.
    function voteChapter(uint256 chapterId, bool like) external {
        require(chapterId < chapters.length, "Invalid chapter");
        require(!hasVoted[chapterId][msg.sender], "Already voted");

        hasVoted[chapterId][msg.sender] = true;
        voteIsLike[chapterId][msg.sender] = like;

        Chapter storage c = chapters[chapterId];
        if (like) {
            c.likes += 1;
        } else {
            c.dislikes += 1;
        }

        emit ChapterVoted(chapterId, msg.sender, like, c.likes, c.dislikes);
    }

    /// @notice Returns total number of chapters created (including example).
    function totalChapters() external view returns (uint256) {
        return chapters.length;
    }
}
