function Utility_SetAppFontSize(app, newSize)
    comps = app.NeuromodToolboxMainWindowUIFigure.Children;     % get all components
    updateFont(comps, newSize);
    
    %if strcmp(app.NeuromodToolboxMainWindowUIFigure.WindowState,"fullscreen")
    if isprop(app,'NeuroModLabel')
        app.NeuroModLabel.FontSize = 32;
        app.MainWindowLabel.FontSize = 22;
    end
    %end
end

function updateFont(comps, newSize)
    for c = comps'
        % If object has a FontSize property
        if isprop(c, 'FontSize')
            c.FontSize = newSize;
        end
        
        % If it contains children (panels, tabs, grids, etc.)
        if isprop(c, 'Children') && ~isempty(c.Children)
            updateFont(c.Children, newSize);
        end
    end
end

