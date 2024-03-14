--{Version Checker}-- 
if Config.CheckVersion then 
    Citizen.CreateThread(function()
        updatePath = "/BestyFir3TM/NvX_Admin" -- Git Repository 
        resourceName = "NvX_Admin ("..GetCurrentResourceName()..")" 

        function checkVersion(err, responseText, headers) 
            curVersion = LoadResourceFile(GetCurrentResourceName(), "version") -- File On Root Git 

            if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then 
                print('^7[^3NvX_Admin^7] - There Is New Update For This Admin Menu, Download It :)')
                print('^7[^3NvX_Admin^7] - Here Is The Link To Download New Version: https://github.com'..updatePath..'')

            else 
                print('^7[^3NvX_Admin^7] - No Update Avaible, Enjoy :)')
            end
        end

        PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
    end)
else
    print('^7[^3NvX_Admin^7] - Check Version For Updates Is Disabled, If You Need; Activate It From Config.CheckVersion')
end