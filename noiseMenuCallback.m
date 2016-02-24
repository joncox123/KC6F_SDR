function noiseMenuCallback(source, callbackdata, menu)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

global noiseFilter;
noiseFilter = source.Label;

%% Uncheck all menu items
childMenus = menu.Children;
for k=1:numel(childMenus)
    childMenus(k).Checked = 'off';
end

% Check this menu item
source.Checked = 'on';

end

