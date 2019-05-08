function kb = GetKeyboard(withscanner)
kb = 0;
devices = PsychHID('devices');
switch withscanner
    case 0
        for k = 1:length(devices)
            if (strcmp(devices(k).usageName,'Keyboard'))
                if (devices(k).index > kb)
                    kb = devices(k).index;
                end
            end
        end
    case 1
        for k = 1:length(devices)
            if (strcmp(devices(k).usageName,'Keyboard') && devices(k).vendorID == 6171)
                if (devices(k).index > kb)
                    kb = devices(k).index;
                end
            end
        end    
end
end
