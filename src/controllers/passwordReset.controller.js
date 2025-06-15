const { User } = require("../models/User");
const bcrypt = require("bcrypt");
const passwordResetController = async (req, res) => {
    try{
        const {userId, oldPassword, newPassword} = req.body;
        // Input validation - ensures all fields are provided
        if(!userId || !oldPassword || !newPassword){
            return res.status(400).json({
                status: 400,
                message: "Please fill out all the fields",
                data: [],
                error: "Missing fields"
            });
        }
        //Find user in database by userId
        const existingUser = await User.findOne({ userId: userId });
        // Check if old password matches
        if(!existingUser){
            return res.status(404).json({
                status: 404,
                message: "User not found",
                data: [],
                error: "User does not exist"
            });
        }
        const isOldPasswordValid = await bcrypt.compare(oldPassword, existingUser.password);
        if(isOldPasswordValid){
            // Hash the new password
            const salt = await bcrypt.genSalt(10);
            const hashedNewPassword = await bcrypt.hash(newPassword, salt);
            // Update user password
            existingUser.password = hashedNewPassword;
            // Save updated user record
            await User.findByIdAndUpdate(
                  userId,
                  { password: hashedNewPassword },
                  { new: true }
                );
            return res.status(200).json({
                status: 200,
                message: "Password updated successfully",
                data: []
            });
        }
        else{
            return res.status(403).json({
                status: 403,
                message: "Unauthorized",
                data: [],
                error: "Invalid credentials"
            });
        }
    }
    catch(e){
        return res.status(500).json({
            status: 500,
            message: "Server Error",
            data: [],
            error: e.message
        });
    }
}

module.exports = { passwordResetController };