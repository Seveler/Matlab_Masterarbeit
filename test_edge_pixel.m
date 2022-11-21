clear all;

masksize = 5;
pixel_positions = [0,0,0,0,0;
                   0,0,0,1,1;
                   0,1,1,1,0;
                   0,1,0,1,0;
                   0,0,0,0,0];
pixel_positions = imcomplement(pixel_positions);
imshow(pixel_positions);
edgeisblack = false;
        for top=1:masksize
            if (pixel_positions(1,top) == 0)
                edgeisblack = true;
                return;
            end
        end
        if(~edgeisblack)
            for bottom=1:masksize
                if (pixel_positions(masksize,bottom) == 0)
                    edgeisblack = true;
                    return;
                end
            end
        end
        if(~edgeisblack)
            for left=2:masksize-1
                if (pixel_positions(left,1) == 0)
                    edgeisblack = true;
                    return;
                end
            end
        end
        if(~edgeisblack)
            for right=2:masksize-1
                if (pixel_positions(right,masksize) == 0)
                    edgeisblack = true;
                    return;
                end
            end
        end
