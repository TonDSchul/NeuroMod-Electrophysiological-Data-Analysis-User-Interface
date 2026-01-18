% search_mlapp_methods.m
% Search .mlapp files (including zipped .mlapp packages) for a text string.
% Usage:
%   mainFolder   = 'C:\path\to\project';
%   searchString = 'Utility_Plot_Interactive_Probe_View';
%   results = search_mlapp_methods(mainFolder, searchString);

function results = search_mlapp_methods(mainFolder, searchString)
if nargin < 1 || isempty(mainFolder), mainFolder = pwd; end
if nargin < 2, error('Specify a search string.'); end

% Find .mlapp files recursively
mlappFiles = dir(fullfile(mainFolder, '**', '*.mlapp'));

results = struct('mlappPath', {}, 'innerPath', {}, 'matchSnippet', {});

for k = 1:numel(mlappFiles)
    mlappPath = fullfile(mlappFiles(k).folder, mlappFiles(k).name);
    fprintf('Checking: %s\n', mlappPath);
    
    % Detect if file is a zip archive (starts with 'PK')
    isZip = false;
    fid = fopen(mlappPath, 'rb');
    if fid ~= -1
        hdr = fread(fid, 2, 'uint8=>char')';
        fclose(fid);
        if strcmp(hdr, 'PK')
            isZip = true;
        end
    end
    
    if isZip
        % Unzip to a temporary folder and search all extracted files
        tempFolder = fullfile(tempdir, ['mlapp_unzip_' char(java.util.UUID.randomUUID)]);
        mkdir(tempFolder);
        cleanupObj = onCleanup(@() rmdir(tempFolder, 's'));
        try
            unzip(mlappPath, tempFolder);
        catch
            warning('Could not unzip: %s', mlappPath);
            continue;
        end
        
        extracted = dir(fullfile(tempFolder, '**', '*.*'));
        for e = 1:numel(extracted)
            if extracted(e).isdir, continue; end
            extPath = fullfile(extracted(e).folder, extracted(e).name);
            try
                txt = fileread(extPath);
            catch
                continue;
            end
            idx = strfind(txt, searchString);
            if ~isempty(idx)
                % Create small snippet with context (approx. 120 chars around first match)
                pos = idx(1);
                startPos = max(1, pos - 60);
                endPos   = min(length(txt), pos + length(searchString) + 59);
                snippet = txt(startPos:endPos);
                results(end+1) = struct( ... %#ok<SAGROW>
                    'mlappPath', mlappPath, ...
                    'innerPath', strrep(extPath, [tempFolder filesep], ''), ...
                    'matchSnippet', snippet);
                fprintf('  Match inside (unzipped): %s\n', results(end).innerPath);
            end
        end
        
    else
        % Treat as plain text (XML .mlapp). Read as text and search.
        try
            txt = fileread(mlappPath);
        catch
            warning('Could not read: %s', mlappPath);
            continue;
        end
        idx = strfind(txt, searchString);
        if ~isempty(idx)
            pos = idx(1);
            startPos = max(1, pos - 60);
            endPos   = min(length(txt), pos + length(searchString) + 59);
            snippet = txt(startPos:endPos);
            results(end+1) = struct( ... %#ok<SAGROW>
                'mlappPath', mlappPath, ...
                'innerPath', '<in-file XML>', ...
                'matchSnippet', snippet);
            fprintf('  Match in XML: %s\n', mlappPath);
        end
    end
end

% Summary
if isempty(results)
    disp('No .mlapp files found containing the specified string.');
else
    disp('--- Results ---');
    for r = 1:numel(results)
        fprintf('%d) %s\n   inside: %s\n   snippet: %s\n\n', ...
            r, results(r).mlappPath, results(r).innerPath, trimSnippet(results(r).matchSnippet));
    end
end
end

function s = trimSnippet(snip)
% Remove newlines and compress whitespace for concise display
s = regexprep(snip, '\s+', ' ');
maxLen = 240;
if length(s) > maxLen
    s = [s(1:floor(maxLen/2)) ' ... ' s(end-floor(maxLen/2)+1:end)];
end
end
