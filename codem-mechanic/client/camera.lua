mainCam, frontCam, wheelsteringCam, lightCam, rearCam, leftCam, rightCam, topCam, interiorCam, wheelCam =
    nil, nil, nil,
    nil, nil, nil,
    nil, nil,
    nil, nil
RegisterNUICallback('cancelCamera', function()
    changeCamera('mainCam')
    local Vehicle = GetVehiclePedIsUsing(PlayerPedId())
    for i = 0, 7 do
        local door = GetVehicleDoorAngleRatio(Vehicle, i)
        if door > 0 then
            SetVehicleDoorShut(Vehicle, i, false)
        end
    end
end)
function CreateCamVehicle()
    local ped = PlayerPedId()
    local customVehicle = GetVehiclePedIsIn(ped, false)
    local vehPos = GetEntityCoords(customVehicle)
    local maincamPos = GetOffsetFromEntityInWorldCoords(customVehicle, -4.1, 4.0, 2.0)
    local mainheadingToObject = GetHeadingFromVector_2d(vehPos.x - maincamPos.x, vehPos.y - maincamPos.y)
    mainCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', maincamPos.x, maincamPos.y, maincamPos.z, -20.0, 0.0,
        mainheadingToObject,
        GetGameplayCamFov(), false, 2)
    local lightcamPos = GetOffsetFromEntityInWorldCoords(customVehicle, 0.1, 6.0, 1.0)
    local lightheadingToObject = GetHeadingFromVector_2d(vehPos.x - lightcamPos.x, vehPos.y - lightcamPos.y)
    lightCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', lightcamPos.x, lightcamPos.y, lightcamPos.z, -20.0, 0.0,
        lightheadingToObject,
        GetGameplayCamFov(), false, 2)
    local frontcamPos = GetOffsetFromEntityInWorldCoords(customVehicle, 0.1, 4.0, 2.0)
    local frontheadingToObject = GetHeadingFromVector_2d(vehPos.x - frontcamPos.x, vehPos.y - frontcamPos.y)
    frontCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', frontcamPos.x, frontcamPos.y, frontcamPos.z, -40.0, 0.0,
        frontheadingToObject,
        GetGameplayCamFov(), false, 2)
    local rearcamPos = GetOffsetFromEntityInWorldCoords(customVehicle, 0.1, -5.0, 1.5)
    local rearheadingToObject = GetHeadingFromVector_2d(vehPos.x - rearcamPos.x, vehPos.y - rearcamPos.y)
    rearCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', rearcamPos.x, rearcamPos.y, rearcamPos.z, -20.0, 0.0,
        rearheadingToObject,
        GetGameplayCamFov(), false, 2)
    local leftcamPos = GetOffsetFromEntityInWorldCoords(customVehicle, 4.5, -3.0, 0.5)
    local leftheadingToObject = GetHeadingFromVector_2d(vehPos.x - leftcamPos.x, vehPos.y - leftcamPos.y)
    leftCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', leftcamPos.x, leftcamPos.y, leftcamPos.z, 0.0, 0.0,
        leftheadingToObject,
        GetGameplayCamFov(), false, 2)
    local rightcamPos = GetOffsetFromEntityInWorldCoords(customVehicle, -4.5, 2.0, 0.5)
    local rightheadingToObject = GetHeadingFromVector_2d(vehPos.x - rightcamPos.x, vehPos.y - rightcamPos.y)
    rightCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', rightcamPos.x, rightcamPos.y, rightcamPos.z, 0.0, 0.0,
        rightheadingToObject,
        GetGameplayCamFov(), false, 2)
    local topcamPos = GetOffsetFromEntityInWorldCoords(customVehicle, -0.5, 2.0, 2.0)
    local topheadingToObject = GetHeadingFromVector_2d(vehPos.x - topcamPos.x, vehPos.y - topcamPos.y)
    topCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', topcamPos.x, topcamPos.y, topcamPos.z, -30.0, 0.0,
        topheadingToObject,
        GetGameplayCamFov(), false, 2)
    local wheelsteringcamPos = GetOffsetFromEntityInWorldCoords(customVehicle, 2, -2.0, 2.0)
    local wheelsteringcamPosheadingToObject = GetHeadingFromVector_2d(vehPos.x - wheelsteringcamPos.x,
        vehPos.y - wheelsteringcamPos.y)
    wheelsteringCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', vehPos.x + 0.5, vehPos.y, vehPos.z + 0.5, 0.0, 0.0,
        wheelsteringcamPosheadingToObject, GetGameplayCamFov(), false, 2)

    local interiorcamPos = GetOffsetFromEntityInWorldCoords(customVehicle, 4.0, -17.5, 4.0)
    local interiorcamPosheadingToObject = GetHeadingFromVector_2d(vehPos.x - interiorcamPos.x,
        vehPos.y - interiorcamPos.y)
    interiorCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', vehPos.x + 0.1, vehPos.y + 0.5, vehPos.z + 0.5, 0.0, 0.0,
        interiorcamPosheadingToObject, GetGameplayCamFov(), false, 2)

    local wheelCamPos = GetOffsetFromEntityInWorldCoords(customVehicle, -3.1, -2.5, 0.0)
    local wheelCamheadingToObject = GetHeadingFromVector_2d(vehPos.x - wheelCamPos.x, vehPos.y - wheelCamPos.y)
    wheelCam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', wheelCamPos.x, wheelCamPos.y, wheelCamPos.z, 0.0, 0.0,
        wheelCamheadingToObject,
        GetGameplayCamFov(), false, 2)
end

local isSwitching = false
local currentActiveCam = nil
function changeCamera(camName)
    local cameraMapping = {
        frontCam = frontCam,
        wheelsteringCam = wheelsteringCam,
        lightCam = lightCam,
        rearCam = rearCam,
        leftCam = leftCam,
        rightCam = rightCam,
        topCam = topCam,
        interiorCam = interiorCam,
        wheelCam = wheelCam,
        mainCam = mainCam
    }
    local currentCam = GetRenderingCam()
    if not cameraMapping[camName] then
        return
    end
    if isSwitching then
        return
    end
    if currentActiveCam == cameraMapping[camName] then
        return
    end

    isSwitching = true

    local switchToCam = function(targetCam)
        if currentCam == -1 then
            SetCamActive(targetCam, true)
            RenderScriptCams(true, true, 500, true, true)
        else
            SetCamActiveWithInterp(targetCam, currentCam, 750, true, true)
        end
    end



    local targetCam = cameraMapping[camName]
    if targetCam then
        switchToCam(targetCam)
        currentActiveCam = targetCam
    end
    Citizen.Wait(750)
    isSwitching = false
end