local mat_default = Material("arc9/arccw_bird.png")
local mat_new = Material("arc9/plus.png")
local mat_reset = Material("arc9/reset.png")
local mat_export = Material("arc9/arrow_up.png")
local mat_import = Material("arc9/arrow_down.png")
local nextpreset = 0

function SWEP:CreatePresetExport()
    local bg = vgui.Create("DFrame")
    bg:SetPos(0, 0)
    bg:SetSize(ScrW(), ScrH())
    bg:SetText("")
    bg:SetTitle("")
    bg:SetDraggable(false)
    bg:ShowCloseButton(false)
    bg.Paint = function(span)
        if !IsValid(self) then return end
        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end
    bg:MakePopup()

    local text = vgui.Create("DTextEntry", bg)
    text:SetSize(ScreenScale(256), ScreenScale(26))
    text:Center()
    text:RequestFocus()
    text:SetFont("ARC9_24")
    text:SetText(self:GeneratePresetExportCode())

    text.OnEnter = function(spaa, kc)
        bg:Close()
        bg:Remove()
    end

    local cancel = vgui.Create("DButton", bg)
    cancel:SetSize((ScreenScale(256) - ScreenScale(2)) / 2, ScreenScale(14))
    cancel:SetText("")
    cancel:SetPos(((ScrW() - ScreenScale(256)) / 2) + ScreenScale(128 + 1), ((ScrH() - ScreenScale(14)) / 2) + ScreenScale(26) + ScreenScale(2))

    cancel.OnMousePressed = function(spaa, kc)
        bg:Close()
        bg:Remove()
    end

    cancel.Paint = function(spaa, w, h)
        if !self:IsValid() then return end
        local Bfg_col = ARC9.GetHUDColor("shadow")

        if spaa:IsHovered() then
            surface.SetDrawColor(ARC9.GetHUDColor("hi"))
        else
            surface.SetDrawColor(ARC9.GetHUDColor("fg"))
        end

        surface.DrawRect(0, 0, w, h)

        local txt = "Close"

        surface.SetTextColor(Bfg_col)
        surface.SetTextPos(ScreenScale(2), ScreenScale(1))
        surface.SetFont("ARC9_12")
        surface.DrawText(txt)
    end
end

function SWEP:CreatePresetImport()
    local bg = vgui.Create("DFrame")
    bg:SetPos(0, 0)
    bg:SetSize(ScrW(), ScrH())
    bg:SetText("")
    bg:SetTitle("")
    bg:SetDraggable(false)
    bg:ShowCloseButton(false)
    bg.Paint = function(span)
        if !IsValid(self) then return end
        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end
    bg:MakePopup()

    local text = vgui.Create("DTextEntry", bg)
    text:SetSize(ScreenScale(256), ScreenScale(26))
    text:Center()
    text:RequestFocus()
    text:SetFont("ARC9_24")
    text:SetText("")

    text.OnEnter = function(spaa, kc)
        self:LoadPresetFromCode(spaa:GetText())

        bg:Close()
        bg:Remove()
    end

    local accept = vgui.Create("DButton", bg)
    accept:SetSize((ScreenScale(256) - ScreenScale(2)) / 2, ScreenScale(14))
    accept:SetText("")
    accept:SetPos((ScrW() - ScreenScale(256)) / 2, ((ScrH() - ScreenScale(14)) / 2) + ScreenScale(26) + ScreenScale(2))

    accept.OnMousePressed = function(spaa, kc)
        self:LoadPresetFromCode(text:GetText())

        bg:Close()
        bg:Remove()
    end

    accept.Paint = function(spaa, w, h)
        if !self:IsValid() then return end
        local Bfg_col = ARC9.GetHUDColor("shadow")

        if spaa:IsHovered() then
            surface.SetDrawColor(ARC9.GetHUDColor("hi"))
        else
            surface.SetDrawColor(ARC9.GetHUDColor("fg"))
        end

        surface.DrawRect(0, 0, w, h)

        local txt = "Import"

        surface.SetTextColor(Bfg_col)
        surface.SetTextPos(ScreenScale(2), ScreenScale(1))
        surface.SetFont("ARC9_12")
        surface.DrawText(txt)
    end

    local cancel = vgui.Create("DButton", bg)
    cancel:SetSize((ScreenScale(256) - ScreenScale(2)) / 2, ScreenScale(14))
    cancel:SetText("")
    cancel:SetPos(((ScrW() - ScreenScale(256)) / 2) + ScreenScale(128 + 1), ((ScrH() - ScreenScale(14)) / 2) + ScreenScale(26) + ScreenScale(2))

    cancel.OnMousePressed = function(spaa, kc)
        bg:Close()
        bg:Remove()
    end

    cancel.Paint = function(spaa, w, h)
        if !self:IsValid() then return end
        local Bfg_col = ARC9.GetHUDColor("shadow")

        if spaa:IsHovered() then
            surface.SetDrawColor(ARC9.GetHUDColor("hi"))
        else
            surface.SetDrawColor(ARC9.GetHUDColor("fg"))
        end

        surface.DrawRect(0, 0, w, h)

        local txt = "Cancel"

        surface.SetTextColor(Bfg_col)
        surface.SetTextPos(ScreenScale(2), ScreenScale(1))
        surface.SetFont("ARC9_12")
        surface.DrawText(txt)
    end
end

function SWEP:CreatePresetName()
    local bg = vgui.Create("DFrame")
    bg:SetPos(0, 0)
    bg:SetSize(ScrW(), ScrH())
    bg:SetText("")
    bg:SetTitle("")
    bg:SetDraggable(false)
    bg:ShowCloseButton(false)
    bg.Paint = function(span)
        if !IsValid(self) then return end
        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end
    bg:MakePopup()

    local text = vgui.Create("DTextEntry", bg)
    text:SetSize(ScreenScale(256), ScreenScale(26))
    text:Center()
    text:RequestFocus()
    text:SetFont("ARC9_24")
    text:SetText("")

    text.OnEnter = function(spaa, kc)
        local txt = text:GetText()
        txt = string.sub(txt, 0, 36)

        if txt != "autosave" and txt != "default" then
        self:SavePreset(txt)
        surface.PlaySound("arc9/shutter.ogg")

        timer.Simple(0.5, function()
            if IsValid(self) and IsValid(self:GetOwner()) then
                self:GetOwner():ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 127), 0.5, 0)
                if self:GetCustomize() then
                    self:CreateHUD_Bottom()
                end
            end
        end)
        end

        bg:Close()
        bg:Remove()
    end

    local accept = vgui.Create("DButton", bg)
    accept:SetSize((ScreenScale(256) - ScreenScale(2)) / 2, ScreenScale(14))
    accept:SetText("")
    accept:SetPos((ScrW() - ScreenScale(256)) / 2, ((ScrH() - ScreenScale(14)) / 2) + ScreenScale(26) + ScreenScale(2))

    accept.OnMousePressed = function(spaa, kc)
        local txt = text:GetText()
        txt = string.sub(txt, 0, 36)
        -- if txt == "" then txt = "UNNAMED" end

        -- self:SavePreset(os.date("%y%m%d%H%M%S", os.time()))
        self:SavePreset(txt)
        surface.PlaySound("arc9/shutter.ogg")

        timer.Simple(0.5, function()
            if IsValid(self) and IsValid(self:GetOwner()) then
                self:GetOwner():ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 127), 0.5, 0)
                if self:GetCustomize() then
                    self:CreateHUD_Bottom()
                end
            end
        end)

        bg:Close()
        bg:Remove()
    end

    accept.Paint = function(spaa, w, h)
        if !self:IsValid() then return end
        local Bfg_col = ARC9.GetHUDColor("shadow")

        if spaa:IsHovered() then
            surface.SetDrawColor(ARC9.GetHUDColor("hi"))
        else
            surface.SetDrawColor(ARC9.GetHUDColor("fg"))
        end

        surface.DrawRect(0, 0, w, h)

        local txt = "Save"

        surface.SetTextColor(Bfg_col)
        surface.SetTextPos(ScreenScale(2), ScreenScale(1))
        surface.SetFont("ARC9_12")
        surface.DrawText(txt)
    end

    local cancel = vgui.Create("DButton", bg)
    cancel:SetSize((ScreenScale(256) - ScreenScale(2)) / 2, ScreenScale(14))
    cancel:SetText("")
    cancel:SetPos(((ScrW() - ScreenScale(256)) / 2) + ScreenScale(128 + 1), ((ScrH() - ScreenScale(14)) / 2) + ScreenScale(26) + ScreenScale(2))

    cancel.OnMousePressed = function(spaa, kc)
        bg:Close()
        bg:Remove()
    end

    cancel.Paint = function(spaa, w, h)
        if !self:IsValid() then return end
        local Bfg_col = ARC9.GetHUDColor("shadow")

        if spaa:IsHovered() then
            surface.SetDrawColor(ARC9.GetHUDColor("hi"))
        else
            surface.SetDrawColor(ARC9.GetHUDColor("fg"))
        end

        surface.DrawRect(0, 0, w, h)

        local txt = "Cancel"

        surface.SetTextColor(Bfg_col)
        surface.SetTextPos(ScreenScale(2), ScreenScale(1))
        surface.SetFont("ARC9_12")
        surface.DrawText(txt)
    end
end

function SWEP:CreateHUD_Presets(scroll)
    local presetlist = self:GetPresets()

    local plusbtn = vgui.Create("DButton", scroll)
    plusbtn:SetSize(ScreenScale(48), ScreenScale(48))
    plusbtn:DockMargin(ScreenScale(2), 0, 0, 0)
    plusbtn:Dock(LEFT)
    plusbtn:SetText("")
    scroll:AddPanel(plusbtn)

    plusbtn.DoClick = function(self2)
        if nextpreset > CurTime() then return end
        nextpreset = CurTime() + 1

        self:CreatePresetName()
    end

    plusbtn.DoRightClick = function(self2)
        if nextpreset > CurTime() then return end
        nextpreset = CurTime() + 1

        -- local txt = os.date( "%I.%M%p", os.time() )
        -- if txt:Left(1) == "0" then txt = txt:Right( #txt-1 ) end
        local txt = "PRESET "
        local num = 0

        for _, preset in ipairs(presetlist) do
            local psname = self:GetPresetName(preset)
            if string.StartWith(psname, txt) then
                local qsnum = tonumber(string.sub(psname, string.len(txt) + 1))

                if qsnum and qsnum > num then
                    num = qsnum
                end
            end
        end

        txt = txt .. tostring(num + 1)

        self:SavePreset( txt )
        surface.PlaySound("arc9/shutter.ogg")

        timer.Simple(0.5, function()
            if IsValid(self) and IsValid(self:GetOwner()) then
                self:GetOwner():ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 127), 0.5, 0)
                if self:GetCustomize() then
                    self:CreateHUD_Bottom()
                end
            end
        end)
    end

    plusbtn.Paint = function(self2, w, h)
        if !IsValid(self) then return end

        local col1 = ARC9.GetHUDColor("fg")
        local name = "SAVE"
        local icon = mat_new
        local hasbg = false

        if self2:IsHovered() then
            col1 = ARC9.GetHUDColor("shadow")
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.DrawRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))
            self.CustomizeHints["Select"]   = "Create Preset"
            self.CustomizeHints["Deselect"] = "Quicksave"

            if self2:IsHovered() then
                surface.SetDrawColor(ARC9.GetHUDColor("hi"))
            else
                surface.SetDrawColor(ARC9.GetHUDColor("fg"))
            end

            surface.DrawRect(0, 0, w - ScreenScale(1), h - ScreenScale(1))
            hasbg = true
        else
            surface.SetDrawColor(ARC9.GetHUDColor("shadow", 100))
            surface.DrawRect(0, 0, w, h)
        end

        if !hasbg then
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(ScreenScale(2), ScreenScale(2), w - ScreenScale(1), h - ScreenScale(1))
        end

        surface.SetDrawColor(col1)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

        if !hasbg then
            surface.SetTextColor(ARC9.GetHUDColor("shadow"))
            surface.SetTextPos(ScreenScale(14), ScreenScale(1))
            surface.SetFont("ARC9_10")
            self:DrawTextRot(self2, name, 0, 0, ScreenScale(3), ScreenScale(1), ScreenScale(46), true)
        end

        surface.SetTextColor(col1)
        surface.SetTextPos(ScreenScale(13), 0)
        surface.SetFont("ARC9_10")
        self:DrawTextRot(self2, name, 0, 0, ScreenScale(2), 0, ScreenScale(46), false)
    end

    local resetbtn = vgui.Create("DButton", scroll)
    resetbtn:SetSize(ScreenScale(48), ScreenScale(48))
    resetbtn:DockMargin(ScreenScale(2), 0, 0, 0)
    resetbtn:Dock(LEFT)
    resetbtn:SetText("")
    scroll:AddPanel(resetbtn)

    resetbtn.DoClick = function(self2)
        surface.PlaySound("arc9/uninstall.wav")
        self:ClearPreset()
    end

    resetbtn.Paint = function(self2, w, h)
        if !IsValid(self) then return end

        local col1 = ARC9.GetHUDColor("fg")
        local name = "RESET"
        local icon = mat_reset
        local hasbg = false

        if self2:IsHovered() then
            col1 = ARC9.GetHUDColor("shadow")
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.DrawRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))
            self.CustomizeHints["Select"]   = "Reset to default"
            self.CustomizeHints["Deselect"] = ""

            if self2:IsHovered() then
                surface.SetDrawColor(ARC9.GetHUDColor("hi"))
            else
                surface.SetDrawColor(ARC9.GetHUDColor("fg"))
            end

            surface.DrawRect(0, 0, w - ScreenScale(1), h - ScreenScale(1))
            hasbg = true
        else
            surface.SetDrawColor(ARC9.GetHUDColor("shadow", 100))
            surface.DrawRect(0, 0, w, h)
        end

        if !hasbg then
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(ScreenScale(2), ScreenScale(2), w - ScreenScale(1), h - ScreenScale(1))
        end

        surface.SetDrawColor(col1)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

        if !hasbg then
            surface.SetTextColor(ARC9.GetHUDColor("shadow"))
            surface.SetTextPos(ScreenScale(14), ScreenScale(1))
            surface.SetFont("ARC9_10")
            self:DrawTextRot(self2, name, 0, 0, ScreenScale(3), ScreenScale(1), ScreenScale(46), true)
        end

        surface.SetTextColor(col1)
        surface.SetTextPos(ScreenScale(13), 0)
        surface.SetFont("ARC9_10")
        self:DrawTextRot(self2, name, 0, 0, ScreenScale(2), 0, ScreenScale(46), false)
    end

    local exportbtn = vgui.Create("DButton", scroll)
    exportbtn:SetSize(ScreenScale(48), ScreenScale(48))
    exportbtn:DockMargin(ScreenScale(2), 0, 0, 0)
    exportbtn:Dock(LEFT)
    exportbtn:SetText("")
    scroll:AddPanel(exportbtn)

    exportbtn.DoClick = function(self2)
        if nextpreset > CurTime() then return end
        nextpreset = CurTime() + 1

        self:CreatePresetExport()
    end

    exportbtn.Paint = function(self2, w, h)
        if !IsValid(self) then return end

        local col1 = ARC9.GetHUDColor("fg")
        local name = "EXPORT"
        local icon = mat_export
        local hasbg = false

        if self2:IsHovered() then
            col1 = ARC9.GetHUDColor("shadow")
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.DrawRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))
            self.CustomizeHints["Select"]   = "Export Preset"

            if self2:IsHovered() then
                surface.SetDrawColor(ARC9.GetHUDColor("hi"))
            else
                surface.SetDrawColor(ARC9.GetHUDColor("fg"))
            end

            surface.DrawRect(0, 0, w - ScreenScale(1), h - ScreenScale(1))
            hasbg = true
        else
            surface.SetDrawColor(ARC9.GetHUDColor("shadow", 100))
            surface.DrawRect(0, 0, w, h)
        end

        if !hasbg then
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(ScreenScale(2), ScreenScale(2), w - ScreenScale(1), h - ScreenScale(1))
        end

        surface.SetDrawColor(col1)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

        if !hasbg then
            surface.SetTextColor(ARC9.GetHUDColor("shadow"))
            surface.SetTextPos(ScreenScale(14), ScreenScale(1))
            surface.SetFont("ARC9_10")
            self:DrawTextRot(self2, name, 0, 0, ScreenScale(3), ScreenScale(1), ScreenScale(46), true)
        end

        surface.SetTextColor(col1)
        surface.SetTextPos(ScreenScale(13), 0)
        surface.SetFont("ARC9_10")
        self:DrawTextRot(self2, name, 0, 0, ScreenScale(2), 0, ScreenScale(46), false)
    end

    local importbtn = vgui.Create("DButton", scroll)
    importbtn:SetSize(ScreenScale(48), ScreenScale(48))
    importbtn:DockMargin(ScreenScale(2), 0, 0, 0)
    importbtn:Dock(LEFT)
    importbtn:SetText("")
    scroll:AddPanel(importbtn)

    importbtn.DoClick = function(self2)
        if nextpreset > CurTime() then return end
        nextpreset = CurTime() + 1

        self:CreatePresetImport()
    end

    importbtn.Paint = function(self2, w, h)
        if !IsValid(self) then return end

        local col1 = ARC9.GetHUDColor("fg")
        local name = "IMPORT"
        local icon = mat_import
        local hasbg = false

        if self2:IsHovered() then
            col1 = ARC9.GetHUDColor("shadow")
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.DrawRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))
            self.CustomizeHints["Select"]   = "Import Preset"

            if self2:IsHovered() then
                surface.SetDrawColor(ARC9.GetHUDColor("hi"))
            else
                surface.SetDrawColor(ARC9.GetHUDColor("fg"))
            end

            surface.DrawRect(0, 0, w - ScreenScale(1), h - ScreenScale(1))
            hasbg = true
        else
            surface.SetDrawColor(ARC9.GetHUDColor("shadow", 100))
            surface.DrawRect(0, 0, w, h)
        end

        if !hasbg then
            surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(ScreenScale(2), ScreenScale(2), w - ScreenScale(1), h - ScreenScale(1))
        end

        surface.SetDrawColor(col1)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

        if !hasbg then
            surface.SetTextColor(ARC9.GetHUDColor("shadow"))
            surface.SetTextPos(ScreenScale(14), ScreenScale(1))
            surface.SetFont("ARC9_10")
            self:DrawTextRot(self2, name, 0, 0, ScreenScale(3), ScreenScale(1), ScreenScale(46), true)
        end

        surface.SetTextColor(col1)
        surface.SetTextPos(ScreenScale(13), 0)
        surface.SetFont("ARC9_10")
        self:DrawTextRot(self2, name, 0, 0, ScreenScale(2), 0, ScreenScale(46), false)
    end

    for _, preset in pairs(presetlist) do
        if preset == "autosave" or preset == "default" then continue end
        local filename = ARC9.PresetPath .. self:GetPresetBase() .. "/" .. preset .. "." .. ARC9.PresetIconFormat
        local btn = vgui.Create("DButton", scroll)
        btn:SetSize(ScreenScale(48), ScreenScale(48))
        btn:DockMargin(ScreenScale(2), 0, 0, 0)
        btn:Dock(LEFT)
        btn:SetText("")
        scroll:AddPanel(btn)
        btn.name = self:GetPresetName(preset)

        if file.Exists(filename, "DATA") then
            btn.icon = Material("data/" .. filename, "smooth")
        end

        btn.DoClick = function(self2)
            self:LoadPreset(preset)
            surface.PlaySound("arc9/preset_install.ogg")
        end

        btn.DoRightClick = function(self2)
            self:DeletePreset(preset)
            surface.PlaySound("arc9/preset_delete.ogg")
            self:CreateHUD_Bottom()
        end

        btn.Paint = function(self2, w, h)
            if !IsValid(self) then return end

            local col1 = ARC9.GetHUDColor("fg")
            local icon = self2.icon or mat_default
            local hasbg = false

            if self2:IsHovered() then
                self.CustomizeHints["Select"]   = "Load"
                self.CustomizeHints["Deselect"] = "Delete"
                col1 = ARC9.GetHUDColor("shadow")
                surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
                surface.DrawRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

                if self2:IsHovered() then
                    surface.SetDrawColor(ARC9.GetHUDColor("hi"))
                else
                    surface.SetDrawColor(ARC9.GetHUDColor("fg"))
                end

                surface.DrawRect(0, 0, w - ScreenScale(1), h - ScreenScale(1))
                hasbg = true
            else
                surface.SetDrawColor(ARC9.GetHUDColor("shadow", 100))
                surface.DrawRect(0, 0, w, h)
            end

            local name = self2.name

            if !hasbg then
                surface.SetDrawColor(ARC9.GetHUDColor("shadow"))
                surface.SetMaterial(icon)
                surface.DrawTexturedRect(ScreenScale(2), ScreenScale(2), w - ScreenScale(1), h - ScreenScale(1))

                surface.SetTextColor(ARC9.GetHUDColor("shadow"))
                surface.SetTextPos(ScreenScale(14), ScreenScale(1))
                surface.SetFont("ARC9_10")
                self:DrawTextRot(self2, name, 0, 0, ScreenScale(3), ScreenScale(1), ScreenScale(46), true)
            end

            surface.SetDrawColor(col1)
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(ScreenScale(1), ScreenScale(1), w - ScreenScale(1), h - ScreenScale(1))

            surface.SetTextColor(col1)
            surface.SetTextPos(ScreenScale(13), 0)
            surface.SetFont("ARC9_10")
            self:DrawTextRot(self2, name, 0, 0, ScreenScale(2), 0, ScreenScale(46), false)
        end
    end
end