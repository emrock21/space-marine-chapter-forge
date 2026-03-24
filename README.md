# Space Marine Chapter Forge

An on-chain registry where users can create their own custom Space Marine chapters, complete with lore, gene‑father, heroic deeds, and official motto.  
Other users may vote **like** or **dislike** each chapter, creating a decentralized popularity index of fan‑made Astartes chapters.

This project is purely textual and non-financial.

---

## Contract Address and Verification

The contract is deployed and verified on BaseScan:

**https://basescan.org/address/0x36c6c418a29fd334e9666d6ce710e2f15d0ff228#code**

From this page you can:

- Inspect the verified source code  
- Read all chapters in `chapters`  
- Call `createChapter` to register a new Space Marine chapter  
- Call `voteChapter` to like/dislike a chapter  
- Track `ChapterCreated` and `ChapterVoted` events  

---

## Contract Overview

Main file: `contracts/SpaceMarineChapterForge.sol`

The contract exposes:

- `createChapter(string name, string geneFather, string history, string heroicDeeds, string motto)`  
- `voteChapter(uint256 chapterId, bool like)`  
- `totalChapters()`  
- `chapters(uint256)`  

Each **Chapter** contains:

- `name` – chapter name  
- `geneFather` – Primarch or genetic progenitor  
- `history` – lore / background  
- `heroicDeeds` – notable deeds  
- `motto` – official motto  
- `creator` – address that created it  
- `createdAt` – timestamp  
- `likes` / `dislikes` – vote counts  

---

## Safety

This contract is intentionally minimal and safe:

- No `payable` functions  
- No ETH transfers  
- No external calls  
- No owner or admin  
- No token logic  
- No selfdestruct  

Users only pay gas to write text on-chain.

---

## How to Use (Remix)

```solidity
createChapter(
  "Sons of the Obsidian Star",
  "Rogal Dorn",
  "A chapter forged in the void, guardians of forgotten watch‑fortresses.",
  "Held the Line of Black Suns for 77 days against impossible odds.",
  "Endure Unto Victory"
);

voteChapter(1, true);
