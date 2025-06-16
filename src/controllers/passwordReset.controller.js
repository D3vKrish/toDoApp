const { User } = require("../models/User");
const bcrypt = require("bcrypt");
const passwordResetController = async (req, res) => {
    try {
        const { userId, newPassword } = req.body;
        // Input validation - ensures all fields are provided
        if (!userId || !newPassword) {
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
        if (!existingUser) {
            return res.status(404).json({
                status: 404,
                message: "User not found",
                data: [],
                error: "User does not exist"
            });
        }
        const isSamePassword = await bcrypt.compare(newPassword, existingUser.password);
        if (isSamePassword) {
            return res.status(400).json({
                status: 400,
                message: "New password cannot be the same as the old password",
                data: [],
                error: "Password reuse not allowed"
            });
        }

        // Hash the new password
        const salt = await bcrypt.genSalt(10);
        const hashedNewPassword = await bcrypt.hash(newPassword, salt);
        // Update user password
        existingUser.password = hashedNewPassword;
        // Save updated user record
        await existingUser.save();
        // Return success response
        return res.status(200).json({
            status: 200,
            message: "Password updated successfully",
            data: []
        });

    }
    catch (e) {
        return res.status(500).json({
            status: 500,
            message: "Server Error",
            data: [],
            error: e.message
        });
    }
}

module.exports = { passwordResetController };