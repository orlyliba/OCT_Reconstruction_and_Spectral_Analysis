function saveAllFigs(h,pathToSave)
if ~isempty(h)
    for indFig = 1:length(h)
        figure(h(indFig))
        saveas(h(indFig),[pathToSave num2str(indFig)],'png');
    end
end