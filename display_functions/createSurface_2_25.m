clc; clear; close all;
pathname = '/home/adlz/Orly/3D for high injection/15-02-25 Lymph GNRs 815 and 925/';
fname = dir([pathname '*.tif']);

for ind = 1:length(fname)
    if ~strcmp(fname(ind).name(16:17+5),'_angio.')
        continue;
    else
        info = imfinfo([pathname fname(ind).name]);
        num_images = numel(info);
        x = info(1).Width;
        y = num_images;
        enface = zeros(x,y,3);
        Thr = 110;
        for k = 1:num_images
            A = imread([pathname fname(ind).name], k);
            v = sum(A,3);
            for j = 1:x
                [~, top] = max(v(:,j));
                % top = find(v(:,j) >= Thr,1,'first');
                enface(j,k,:) = A(top,j,:);
                if enface(j,k,:) < Thr
                    enface(j,k,:) = 0;
                end
            end
        end
        myfilter = fspecial('gaussian',[3 3], 0.2);
        enface = imfilter(enface, myfilter, 'replicate');
        %figure; imshow(uint8(enface))
        enface(:,:,1) = medfilt2(enface(:,:,1),[2 2]);
        enface(:,:,2) = medfilt2(enface(:,:,2),[2 2]);
        enface(:,:,3) = medfilt2(enface(:,:,3),[2 2]);
        figure; imshow(uint8(enface))
        title(num2str(fname(ind).name(1:15)))
        saveas(gca,[pathname fname(ind).name(1:end-4) '_enface'],'png')
        close
    end
end
