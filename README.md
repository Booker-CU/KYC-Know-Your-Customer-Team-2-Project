# KYC Smart Contract
Know Your Customer - Team 2/Project

Ethereum Blockchain Smart Contract 
Solidity/Ganache/Remix IDE

Team Members:
Song Zhao
Richard Bertrand
Leon Zubkov
Booker Sessoms

The goal of this project was to design a smart contract that could be used to verify a persons identity and approve them and share this approved status with a third party(such as a Bank).

The KYC layer would be positioned between a prosepctive new User and a Banking institution.
A user would upload their basic information using a gui form.
A KYC admin layer would have a 3rd party validitor approve that the user is who they say they are.
Once verified the KYC admin would verify the user.

If another party ie a Bank would like to view the new User's information,
they would first need to sign up to the KYC service and be approved by a KYC administator.

Once approved they could view the Users information -ideally having a User consent to it first.
This project is only a prototype, and does not address issues of privacy regarding a new Users private documents -such as passport number, social security number they would need to submit to a KYC service for approval. 

A private blockchain (such as Quorum) might be a better option for a User to upload their information to submit to a KYC service.
There is also a new option called Nightfall that would allow for hidden transactions on a blockchain.



Note:
Our code borrows from the https://github.com/servntire/KYC repository. 
We made changes to the original code restructuring the core struct, and adding two additional structs.
We added separte structs for KYC Admin and a Bank. We also added additional functions and modifiers to the code.
