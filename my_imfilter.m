function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% when operating in convolution mode. See 'help imfilter'. 
% While "correlation" and "convolution" are both called filtering, 
% there is a difference. From 'help filter2':
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should meet the requirements laid out on the project webpage.

% Boundary handling can be tricky as the filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% we look at 'help imfilter', we see that there are several options to deal 
% with boundaries. 
% Please recreate the default behavior of imfilter:
% to pad the input image with zeros, and return a filtered image which matches 
% the input image resolution. 
% A better approach is to mirror or reflect the image content in the padding.

% Uncomment to call imfilter to see the desired behavior.
%output = imfilter(image, filter, 'conv');

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
    % detecting a gray scale or colour image
    [rows, columns, colorChannels] = size(image);

    %detecting even filter
    [f_rows, f_columns] = size(filter);
    if (mod(f_rows, 2) == 0) || (mod(f_columns, 2) == 0)
        error('Error: Even sized filter');
    end
    
    %processing filter for making a convolution
    filter = rot90(filter,2);
    
    %handling colour and grayscale images
    if colorChannels == 3
        redChannel = image(:, :, 1);
        greenChannel = image(:, :, 2);
        blueChannel = image(:, :, 3);
        % padding
        %for padding with zeros just padarray(image, floor(size(filter)/2)) is used
        padded_redChannel = padarray(redChannel, floor(size(filter)/2), 'symmetric');
        padded_greenChannel = padarray(greenChannel, floor(size(filter)/2), 'symmetric');
        padded_blueChannel = padarray(blueChannel, floor(size(filter)/2), 'symmetric');
        padded_img_size = size(padded_redChannel);
        %apply formula of filtering
        for row = ceil(f_rows/2):(padded_img_size(1)-floor(f_rows/2))
            for col = ceil(f_columns/2):(padded_img_size(2)-floor(f_columns/2))
                %red
                image_chunk_red = padded_redChannel(row-floor(f_rows/2):row+floor(f_rows/2), col-floor(f_columns/2):col+floor(f_columns/2));
                image_chunk_red = image_chunk_red .* filter;
                redChannel(row-floor(f_rows/2), col-floor(f_columns/2)) = sum(image_chunk_red(:));
                %green
                image_chunk_green = padded_greenChannel(row-floor(f_rows/2):row+floor(f_rows/2), col-floor(f_columns/2):col+floor(f_columns/2));
                image_chunk_green = image_chunk_green .* filter;
                greenChannel(row-floor(f_rows/2), col-floor(f_columns/2)) = sum(image_chunk_green(:));
                %blue
                image_chunk_blue = padded_blueChannel(row-floor(f_rows/2):row+floor(f_rows/2), col-floor(f_columns/2):col+floor(f_columns/2));
                image_chunk_blue = image_chunk_blue .* filter;
                blueChannel(row-floor(f_rows/2), col-floor(f_columns/2)) = sum(image_chunk_blue(:));
            end
        end
        output = cat(3, redChannel, greenChannel, blueChannel);
    else 
        % padding
        %for padding with zeros just padarray(image, floor(size(filter)/2)) is used
        padded_image = padarray(image, floor(size(filter)/2), 'symmetric');
        padded_img_size = size(padded_image);
        % apply formula of filtering
        for row = ceil(f_rows/2):(padded_img_size(1)-floor(f_rows/2))
            for col = ceil(f_columns/2):(padded_img_size(2)-floor(f_columns/2))
                image_chunk = padded_image(row-floor(f_rows/2):row+floor(f_rows/2), col-floor(f_columns/2):col+floor(f_columns/2));
                image_chunk = image_chunk .* filter;
                image(row-floor(f_rows/2), col-floor(f_columns/2)) = sum(image_chunk(:)); 
            end
        end
        output = image;
    end




