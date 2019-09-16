local ScreenModule = {}

ScreenModule._ScreenLoad = function()
	-- wx.wxMessageBox(tostring(mc.OSIG_HOMED_X))
end

ScreenModule.ScreenLoad = function()
	local is_ok, msg = pcall(screen._ScreenLoad)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule._ScreenUnload = function()
	if screen.IsMDIActive() then
		screen.MDIDialog.Close()
	end
end

ScreenModule.ScreenUnload = function()
	local is_ok, msg = pcall(screen._ScreenUnload)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule._PLCScript = function()
	local x_homed, rc = mc.mcAxisIsHomed(instance, mc.X_AXIS)
	if x_homed ~= screen.is_x_homed then
		if x_homed then
			scr.SetProperty('xHome', 'Bg Color', 'Green')
		else
			scr.SetProperty('xHome', 'Bg Color', 'Red')
		end
		screen.is_x_homed = x_homed
	end
	
	local y_homed, rc = mc.mcAxisIsHomed(instance, mc.Y_AXIS)
	if y_homed ~= screen.is_y_homed then
		if y_homed then
			scr.SetProperty('yHome', 'Bg Color', 'Green')
		else
			scr.SetProperty('yHome', 'Bg Color', 'Red')
		end
		screen.is_y_homed = y_homed
	end
	
	local x_moving = screen.IsAxisMoving(mc.X_AXIS)
	if x_moving ~= screen.is_x_moving then
		if x_moving then
			scr.SetProperty('xMoving', 'Bg Color', 'Green')
		else
			scr.SetProperty('xMoving', 'Bg Color', 'Red')
		end
		screen.is_x_moving = x_moving
	end
	
	local y_moving = screen.IsAxisMoving(mc.Y_AXIS)
	if y_moving ~= screen.is_y_moving then
		if y_moving then
			scr.SetProperty('yMoving', 'Bg Color', 'Green')
		else
			scr.SetProperty('yMoving', 'Bg Color', 'Red')
		end
		screen.is_y_moving = y_moving
	end
end

ScreenModule.PLCScript = function()
	local is_ok, msg = pcall(screen._PLCScript)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule._SignalScript = function(signal, state)
	if signal == mc.OSIG_MACHINE_ENABLED then
		if state == 1 then
			scr.SetProperty('enabledText', 'Label', 'Enabled')
			scr.SetProperty('enableBtn', 'Label', 'Disable')
			scr.SetProperty('enableBtn', 'Bg Color', 'Red')
		else
			scr.SetProperty('enabledText', 'Label', 'Disabled')
			scr.SetProperty('enableBtn', 'Label', 'Enable')
			scr.SetProperty('enableBtn', 'Bg Color', 'Green')
		end
	end
end

ScreenModule.SignalScript = function(signal, state)
	local is_ok, msg = pcall(screen._SignalScript, signal, state)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule.TimerScript = function()

end

ScreenModule.IsAxisMoving = function(axis)
	local still, rc = mc.mcAxisIsStill(instance, axis)
	return not still
end

ScreenModule.GetFeedrateOV = function()
	local percent, rc = mc.mcCntlGetFRO(instance)
	return percent
end

ScreenModule.SetFeedrateOV = function(percent)
	percent = math.max(0, math.min(300, percent))
	local rc = mc.mcCntlSetFRO(instance, percent)
end

ScreenModule.FeedrateOVIncrement = 10
ScreenModule._FeedrateOVDown = function()
	local percent = screen.GetFeedrateOV()
	screen.SetFeedrateOV(percent - screen.FeedrateOVIncrement)
end

ScreenModule.FeedrateOVDown = function()
	mc.mcCntlSetLastError(instance, "Feedrate Override Decrease Pressed")
	local is_ok, msg = pcall(screen._FeedrateOVDown)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule._FeedrateOVUp = function()
	local percent = screen.GetFeedrateOV()
	screen.SetFeedrateOV(percent + screen.FeedrateOVIncrement)
end

ScreenModule.FeedrateOVUp = function()
	mc.mcCntlSetLastError(instance, "Feedrate Override Increase Pressed")
	local is_ok, msg = pcall(screen._FeedrateOVUp)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule._ResetFeedrateOV = function()
	screen.SetFeedrateOV(100)
end

ScreenModule.ResetFeedrateOV = function()
	mc.mcCntlSetLastError(instance, "Reset Feedrate Override Pressed")
	local is_ok, msg = pcall(screen._ResetFeedrateOV)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule.GetSpindleOV = function()
	local percent, rc = mc.mcSpindleGetOverride(instance)
	return percent * 100
end

ScreenModule.SetSpindleOV = function(percent)
	percent = math.max(0, math.min(300, percent))
	local rc = mc.mcSpindleSetOverride(instance, percent / 100)
end

ScreenModule.SpindleOVIncrement = 10
ScreenModule._SpindleOVDown = function()
	local percent = screen.GetSpindleOV()
	screen.SetSpindleOV(percent - screen.SpindleOVIncrement)
end

ScreenModule.SpindleOVDown = function()
	mc.mcCntlSetLastError(instance, "Spindle Override Decrease Pressed")
	local is_ok, msg = pcall(screen._SpindleOVDown)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule._SpindleOVUp = function()
	local percent = screen.GetSpindleOV()
	screen.SetSpindleOV(percent + screen.SpindleOVIncrement)
end

ScreenModule.SpindleOVUp = function()
	mc.mcCntlSetLastError(instance, "Spindle Override Increase Pressed")
	local is_ok, msg = pcall(screen._SpindleOVUp)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule._ResetSpindleOV = function()
	screen.SetSpindleOV(100)
end

ScreenModule.ResetSpindleOV = function()
	mc.mcCntlSetLastError(instance, "Reset Spindle Override Pressed")
	local is_ok, msg = pcall(screen._ResetSpindleOV)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule._ToggleMDI = function()
	if screen.IsMDIActive() then
		screen.MDIDialog.Close()
	else
		local create = function()
			screen.MDIDialog = {}
			screen.MDIDialog.UI = {}

			screen.MDIDialog.UI.dialog = wx.wxDialog(wx.NULL, wx.wxID_ANY, "MDI")
			screen.MDIDialog.UI.sizer = wx.wxBoxSizer(wx.wxVERTICAL)
			screen.MDIDialog.UI.text = wx.wxTextCtrl(screen.MDIDialog.UI.dialog, wx.wxID_ANY, "", wx.wxDefaultPosition, wx.wxSize(250, 150), wx.wxTE_MULTILINE)
			screen.MDIDialog.UI.sizer:Add(screen.MDIDialog.UI.text, 1, wx.wxEXPAND + wx.wxALL, 5)
			screen.MDIDialog.UI.dialog:SetSizerAndFit(screen.MDIDialog.UI.sizer)

			screen.MDIDialog.UI.dialog:Connect(wx.wxEVT_CLOSE_WINDOW, function(event)
				screen.MDIDialog.UI.dialog = nil
				screen.MDIDialog.UI = nil
				screen.MDIDialog = nil

				scr.SetProperty('mdiBtn', 'Bg Color', '')
				scr.SetProperty('startBtn', 'Label', 'Run\nGcode')
				
				event:Skip()
			end)

			screen.MDIDialog.RunMDI = function()
				if screen.MDIDialog.UI.text ~= nil then
					local command = screen.MDIDialog.UI.text:GetValue()
					local rc = mc.mcCntlMdiExecute(instance, command)
				end
			end
			
			screen.MDIDialog.Close = function()
				screen.MDIDialog.UI.dialog:Close()
			end

			screen.MDIDialog.UI.dialog:Show()
		end
		
		local is_ok, msg = pcall(create)
		if not is_ok then
			wx.wxMessageBox(tostring(msg))
		else
			scr.SetProperty('mdiBtn', 'Bg Color', 'Green')
			scr.SetProperty('startBtn', 'Label', 'Run\nMDI')
		end
	end
end

ScreenModule.ToggleMDI = function()
	mc.mcCntlSetLastError(instance, "Toggle MDI Pressed")
	local is_ok, msg = pcall(screen._ToggleMDI)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule.IsMDIActive = function()
	return (screen.MDIDialog ~= nil)
end

ScreenModule._CycleStart = function()
	if not screen.IsMDIActive() then
		mc.mcCntlCycleStart(instance)
	else
		screen.MDIDialog.RunMDI()
	end
end

ScreenModule.CycleStart = function()
	mc.mcCntlSetLastError(instance, "Cycle Start Button Pressed")
	local is_ok, msg = pcall(screen._CycleStart)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

ScreenModule._ToggleMachineCoords = function(axis)
	local dro = "xDRO"
	local led = "xMachine"
	local part_code = "180"
	local machine_code = "100"
	if axis == mc.Y_AXIS then
		dro = "yDRO"
		led = "yMachine"
		part_code = "181"
		machine_code = "101"
	end
	
	local code = scr.GetProperty(dro, 'DRO Code')
	if code == part_code then
		scr.SetProperty(dro, 'DRO Code', machine_code)
		scr.SetProperty(led, 'Bg Color', 'Green')
	else
		scr.SetProperty(dro, 'DRO Code', part_code)
		scr.SetProperty(led, 'Bg Color', 'Red')
	end
end

ScreenModule.ToggleMachineCoords = function(axis)
	mc.mcCntlSetLastError(instance, string.format("Swap Axis %0.0f Coordinates Pressed", axis))
	local is_ok, msg = pcall(screen._ToggleMachineCoords, axis)
	if not is_ok then
		wx.wxMessageBox(tostring(msg))
	end
end

return ScreenModule