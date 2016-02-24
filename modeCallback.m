function modeCallback(source, callbackdata, modeMenu)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global newMode;
newMode = true;

global mode;
mode = source.Label;

%% Uncheck all menu items
childMenus = modeMenu.Children;
for k=1:numel(childMenus)
    childMenus(k).Checked = 'off';
end

% Check this menu item
source.Checked = 'on';

end

