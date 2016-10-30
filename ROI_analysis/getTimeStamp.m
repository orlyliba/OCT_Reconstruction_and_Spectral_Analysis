function output = getTimeStamp(tstamp)

% offset (serial date number for 1/1/1970)
dnOffset = datenum('01-Jan-1970');

% assuming it's read in as a string originally
% tstamp = '1394123509';

% convert to a number, dived by number of seconds
% per day, and add offset
dnNow = str2num(tstamp)/(24*60*60) + dnOffset;

% date string
output = datestr(dnNow); 