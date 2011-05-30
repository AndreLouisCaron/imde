function [ listing ] = list_datasets ()
    % Copyright(c) Andre Caron <andre.louis.caron@usherbrooke.ca>, 2009-2011
    
      % list all files in dataset folder.
    listing = dir('./data/f/');
    listing = {listing(:).name};
    
      % remove whatever's not an image.
    isimage = @(name) ...
        ~strcmp(name,'.') && ~strcmp(name,'..');
    listing = listing(cellfun(isimage, listing));
end
