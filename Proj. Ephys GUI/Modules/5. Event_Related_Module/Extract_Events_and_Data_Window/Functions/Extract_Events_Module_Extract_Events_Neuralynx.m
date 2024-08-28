function [event] = Extract_Events_Module_Extract_Events_Neuralynx(Filename,Path)

[event] = ft_read_event(Filename);

hdr = ft_read_header(Path);

for i=1:length(event)
  % the first sample in the datafile is 1
  event(i).sample = (event(i).timestamp-double(hdr.FirstTimeStamp))./hdr.TimeStampPerSample + 1;
end