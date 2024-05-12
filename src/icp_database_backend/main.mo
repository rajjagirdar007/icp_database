
import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Int "mo:base/Int";

actor AuthMicroservice {
    public type User = {
        uuid : Text;
        email : Text;
        passwordHash : Text; // Password hashes should be stored securely
    };

    private var userCounter : Nat = 0;

    private var users : [User] = [];

    private func generateUUID() : Text {
        let currentTime = Time.now();
        let count = userCounter;
        userCounter += 1;
        return Int.toText(currentTime) # "-" # Nat.toText(count);
    };

    public func createUser(email: Text, password: Text) : async Text {
        let uuid = generateUUID(); // Generate a UUID based on time and a counter
        let passwordHash = hashPassword(password); // Stub for password hashing
        let newUser = {
            uuid = uuid;
            email = email;
            passwordHash = passwordHash;
        };
        users := Array.append<User>(users, [newUser]);
        return uuid; // Return UUID which will be used in Firebase for further details
    };


    public func loginUser(email : Text, password : Text) : async Text {
        let user = Array.find(users, func(u : User) : Bool { return u.email == email });
        switch (user) {
            case (null) { return "no" };
            case (?foundUser) {
                if (verifyPassword(password, foundUser.passwordHash)) {
                    return foundUser.uuid; // Return UUID on successful login
                } else {
                    return "no";
                };
            };
        };
    };

    public func updateUser(uuid : Text, newEmail : Text, newPassword : Text) : async Bool {
        var updated = false;
        users := Array.map<User, User>(
            users,
            func(u : User) : User {
                if (u.uuid == uuid) {
                    updated := true;
                    return {
                        uuid = u.uuid;
                        email = newEmail;
                        passwordHash = hashPassword(newPassword);
                    };
                } else {
                    return u;
                };
            },
        );
        return updated;
    };

    private func hashPassword(password : Text) : Text {
        // Implement a real hash function here
        return password; // Simplified for illustration
    };

    private func verifyPassword(password : Text, hashed : Text) : Bool {
        // Implement password verification against the hash
        return password == hashed; // Simplified for illustration
    };
};
