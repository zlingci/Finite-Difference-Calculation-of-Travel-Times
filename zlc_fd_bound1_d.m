switch d_min_name(2)
    case 'd_rb'
        for i = d_min(2)+1: 1: d_min(3)
            zlc_fd_l;
            zlc_fd_u;
            corner_lu_s = grd_s(pos_A(1)-i, pos_A(2)+i);
            grd_t(pos_A(1)-i, pos_A(2)+i) = grd_t(pos_A(1)-i+1, pos_A(2)+i-1) + sqrt( 2 * (h * corner_lu_s)^2 - (grd_t(pos_A(1)-i+1, pos_A(2)+i) - grd_t(pos_A(1)-i, pos_A(2)+i-1))^2 );
        end
        switch d_min_name(3)
            case 'd_lb'
            for i = d_min(3)+1: 1: d_min(4)
                zlc_fd_u;
            end
            case 'd_ub'
            for i = d_min(3)+1: 1: d_min(4)
                zlc_fd_l;
            end     
        end
    case 'd_lb'
        for i = d_min(2)+1: 1: d_min(3)
            zlc_fd_r;
            zlc_fd_u;
            corner_ru_s = grd_s(pos_A(1)+i, pos_A(2)+i);
            grd_t(pos_A(1)+i, pos_A(2)+i) = grd_t(pos_A(1)+i-1, pos_A(2)+i-1) + sqrt( 2 * (h * corner_ru_s)^2 - (grd_t(pos_A(1)+i-1, pos_A(2)+i) - grd_t(pos_A(1)+i, pos_A(2)+i-1))^2 );
        end
        switch d_min_name(3)
            case 'd_rb'
            for i = d_min(3)+1: 1: d_min(4)
                zlc_fd_u;
            end
            case 'd_ub'
            for i = d_min(3)+1: 1: d_min(4)
                zlc_fd_r;
            end     
        end
    case 'd_ub'
        for i = d_min(2)+1: 1: d_min(3)
            zlc_fd_r;
            zlc_fd_l;
        end
        switch d_min_name(3)
            case 'd_lb'
            for i = d_min(3)+1: 1: d_min(4)
                zlc_fd_r;
            end
            case 'd_rb'
            for i = d_min(3)+1: 1: d_min(4)
                zlc_fd_l;
            end     
        end
end