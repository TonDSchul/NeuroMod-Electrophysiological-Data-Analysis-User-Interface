function Utility_Save_Data_as_CSV(Fullsavefile,PlottedData,xtickLabels)

% Open a file for writing
fid = fopen(Fullsavefile, 'w');
if fid == -1
    error('Cannot open file for writing: %s', Fullsavefile);
end

% Write data to file
for i = 1:length(PlottedData)
    % Check if data exists
    if ~isempty(PlottedData{i})
        %Write XData
        if isfield(PlottedData{i}, 'XData')
           
            [numRows, numCols] = size(PlottedData{i}.XData);
            fprintf(fid, '########################################################################################################################################################################\n');
            fprintf(fid, '#################################################################################### XData: ####################################################################################\n');
            fprintf(fid, '########################################################################################################################################################################\n');
            for row = 1:numRows
                for col = 1:numCols
                    if col == numCols
                        fprintf(fid, '%f', PlottedData{i}.XData(row, col));
                    else
                        fprintf(fid, '%f,', PlottedData{i}.XData(row, col));
                    end
                end
                fprintf(fid, '\n'); % New line after each row
            end

        end

        
        if isfield(PlottedData{i}, 'YData')
            [numRows, numCols] = size(PlottedData{i}.YData);
            fprintf(fid, '########################################################################################################################################################################\n');
            fprintf(fid, '#################################################################################### YData: ####################################################################################\n');
            fprintf(fid, '########################################################################################################################################################################\n');
            for row = 1:numRows
                for col = 1:numCols
                    if col == numCols
                        fprintf(fid, '%f', PlottedData{i}.YData(row, col));
                    else
                        fprintf(fid, '%f,', PlottedData{i}.YData(row, col));
                    end
                end
                fprintf(fid, '\n'); % New line after each row
            end
        end

        if ~isempty(xtickLabels)
            [numRows, numCols] = size(xtickLabels);
            fprintf(fid, '########################################################################################################################################################################\n');
            fprintf(fid, '#################################################################################### XTicks: ####################################################################################\n');
            fprintf(fid, '########################################################################################################################################################################\n');
            for row = 1:numRows
                fprintf(fid, '%s\t', xtickLabels{row});
                %fprintf(fid, '\n'); % New line after each row
            end
        end

        % Write ZData
        if isfield(PlottedData{i}, 'ZData')
            fprintf(fid, '########################################################################################################################################################################\n');
            fprintf(fid, '#################################################################################### ZData: ####################################################################################\n');
            fprintf(fid, '########################################################################################################################################################################\n');
            % Get the size of the ZData matrix
            [numRows, numCols] = size(PlottedData{i}.ZData);

            % Write ZData row by row
            for row = 1:numRows
                for col = 1:numCols
                    if col == numCols
                        fprintf(fid, '%f', PlottedData{i}.ZData(row, col));
                    else
                        fprintf(fid, '%f,', PlottedData{i}.ZData(row, col));
                    end
                end
                fprintf(fid, '\n'); % New line after each row
            end
        end

        % Write ZData
        if isfield(PlottedData{i}, 'CData')
            fprintf(fid, '########################################################################################################################################################################\n');
            fprintf(fid, '#################################################################################### CData: ####################################################################################\n');
            fprintf(fid, '########################################################################################################################################################################\n');
            % Get the size of the ZData matrix
            [numRows, numCols] = size(PlottedData{i}.CData);

            % Write ZData row by row
            for row = 1:numRows
                for col = 1:numCols
                    if col == numCols
                        fprintf(fid, '%f', PlottedData{i}.CData(row, col));
                    else
                        fprintf(fid, '%f,', PlottedData{i}.CData(row, col));
                    end
                end
                fprintf(fid, '\n'); % New line after each row
            end
        end

        if isfield(PlottedData{i}, 'TimeDuration')
            fprintf(fid, 'TimeDuration of Data Snippet [s]:\n');
            fprintf(fid, '%f\n', PlottedData{i}.TimeDuration);
        end

        if isfield(PlottedData{i}, 'Time_Points_Plot')
            fprintf(fid, 'Time Points Data Snippet; from,to [s]:\n');
            fprintf(fid, '%f\n', PlottedData{i}.Time_Points_Plot);
        end

        % Add a blank line for separation
        fprintf(fid, '\n');
    end
end

% Close the file
fclose(fid);
