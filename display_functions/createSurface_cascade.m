clc; clear; close all;
pathname = '/home/adlz/Orly/3D for high injection/15-02-19 lymph GNRs/High res 3D/';
fname = dir([pathname '*.tif']);
cnt = 1;
for ind = 1:length(fname)
    if ~strcmp(fname(ind).name(16:17+5),'_angio.')
        continue;
    else
        info = imfinfo([pathname fname(ind).name]);
        num_images = numel(info);
        x = info(1).Width;
        y = num_images;
        enface(:,:,:,cnt) = zeros(x,y,3);
        Thr = 110;
        for k = 1:num_images
            A = imread([pathname fname(ind).name], k);
            v = sum(A,3);
            for j = 1:x
                [~, top] = max(v(:,j));
                % top = find(v(:,j) >= Thr,1,'first');
                enface(j,k,:,cnt) = A(top,j,:);
                if enface(j,k,:,cnt) < Thr
                    enface(j,k,:,cnt) = 0;
                end
            end
        end
        myfilter = fspecial('gaussian',[3 3], 0.2);
        enface(:,:,:,cnt) = imfilter(enface(:,:,:,cnt), myfilter, 'replicate');
        %figure; imshow(uint8(enface))
        enface(:,:,1,cnt) = medfilt2(enface(:,:,1,cnt),[2 2]);
        enface(:,:,2,cnt) = medfilt2(enface(:,:,2,cnt),[2 2]);
        enface(:,:,3,cnt) = medfilt2(enface(:,:,3,cnt),[2 2]);
%         figure; imshow(uint8(enface))
%         title(num2str(fname(ind).name(1:15)))
%         saveas(gca,[pathname fname(ind).name(1:end-4) '_enface'],'png')
%         close
cnt = cnt+1;
    end
end
figure; imshow(uint8([enface(:,:,:,4);enface(:,:,:,1); enface(:,:,:,2); enface(:,:,:,3)]))
