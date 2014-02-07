function[a,e,V1,V2] = gaussproblem202(R1,R2,TOF,p1,p2,mu,way,method)
% Group 202: Dylan Thomas, Seth Austin, Collin Juba

%Error Messages
if length (R1)~=3 || length (R2)~=3
    error('Input vector(s) are not the correct size. Please input new vectors.')
end
if way~=1 && way~=-1
    error('Input value for "way" is invalid. Input 1 for short way, or -1 for long way.')
end
if method~=1 && method~=2
    error('Input value for "way" is invalid. Input 1 for linear interpolation, or 2 for Newtons Method.')
end

%Changes the matrices into 3x1 vectors
R1 = [R1(1); R1(2); R1(3)];
R2 = [R2(1); R2(2); R2(3)];

% Initialize tolerance and error values
TOL = 10e-12;
err = 1;

% Magnitudes of position vectors
r1 = norm(R1); r2 = norm(R2);

% Finding delta nu. If the long way is chosen, the true anomaly will be
% greater than 180 degrees
dnu = acos(dot(R1,R2)/(r1*r2));
if way == -1;
    dnu = 2*pi - dnu;
end

% Finding k, l, and m values for parameter and semi-major axis functions
k = r1*r2*(1 - cos(dnu));
l = r1 + r2;
m = r1*r2*(1 + cos(dnu));

% Linear Interpolation Method
if method == 1;
    % Calculating p1 guess values
    
    % Semi-major axis
    a1 = (m*k*p1)/((2*m - l^2)*p1^2 + 2*k*l*p1 - k^2); 
    
    % f, g, fdot, and gdot
    f1 = 1 - (r2/p1)*(1 - cos(dnu));
    g1 = (r1*r2*sin(dnu))/sqrt(mu*p1);
    f1dot = sqrt(mu/p1)*tan(dnu/2)*(((1 - cos(dnu))/p1) - (1/r1) - (1/r2));
    g1dot = 1 - (r1/p1)*(1 - cos(dnu));
    
    % eccentricrty
    e1 = sqrt(1 - (p1/a1));
    
    % Determine if orbit is hyperbolic or elliptical and then calculates
    % Eccentric Anomaly and the Time of Flight
    if e1<1
        cosdE1 = 1 - (r1/a1)*(1 - f1);
        sindE1 = (-f1dot*r1*r2)/sqrt(mu*a1);
        dE1 = atan2(sindE1,cosdE1);
        if dE1 < 0 && dnu > pi;
            dE1 = 2*pi + dE1;
        elseif dE1 < 0 && dnu < pi;
            dE1 = -dE1;
        elseif dE1 > 0 && dnu > pi;
            dE1 = 2*pi - dE1;
        end
        t1 = g1 + sqrt(a1^3/mu)*(dE1 - sindE1);
    elseif e1>1
        coshF1 = 1 - (r1/a1)*(1 - f1);
        dF1 = log(coshF1 + sqrt(coshF1^2 - 1));
         if dnu > pi;
             dF1 = -abs(dF1);
         elseif dnu < pi;
             dF1 = abs(dF1);
         end
        t1 = g1 + sqrt((-a1)^3/mu)*(sinh(dF1) - dF1);
    end
    % Error check
    err = abs(TOF - t1);
    
    % Calculating p2 values
    a2 = (m*k*p2)/((2*m - l^2)*p2^2 + 2*k*l*p2 - k^2);
    
    f2 = 1 - (r2/p2)*(1 - cos(dnu));
    g2 = (r1*r2*sin(dnu))/sqrt(mu*p2);
    f2dot = sqrt(mu/p2)*tan(dnu/2)*((1 - cos(dnu))/p2 - 1/r1 - 1/r2);
    g2dot = 1 - (r1/p2)*(1 - cos(dnu));
    
    e2 = sqrt(1 - (p2/a2));
    
    % Checking for hyperbolic or elliptical orbit
    if e2<1
        cosdE2 = 1 - (r1/a2)*(1 - f2);
        sindE2 = (-f2dot*r1*r2)/sqrt(mu*a2);
        dE2 = atan2(sindE2,cosdE2);
        if dE2 < 0 && dnu > pi;
            dE2 = 2*pi + dE2;
        elseif dE2 < 0 && dnu < pi;
            dE2 = -dE2;
        elseif dE2 > 0 && dnu > pi;
            dE2 = 2*pi - dE2;
        end
        t2 = g2 + sqrt(a2^3/mu)*(dE2 - sindE2);
    elseif e2>1
        coshF2 = 1 - (r1/a2)*(1 - f2);
        dF2 = log(coshF2 + sqrt(coshF2^2 - 1));
        if dnu > pi;
            dF2 = -abs(dF2);
        elseif dnu < pi;
            dF2 = abs(dF2);
        end
        t2 = g2 + sqrt((-a2)^3/mu)*(sinh(dF2) - dF2);
    end
    
    err = abs(TOF - t2);
    
    while err > TOL;
        % Finding a new parameter based upon old ones and their TOFs
        pnew = p2 + ((TOF-t2)*(p2 - p1))/(t2-t1);
        
        % Calculating orbital elements for new parameter
        a = (m*k*pnew)/((2*m - l^2)*pnew^2 + 2*k*l*pnew - k^2);
        
        f = 1 - (r2/pnew)*(1 - cos(dnu));
        g = (r1*r2*sin(dnu))/sqrt(mu*pnew);
        fdot = sqrt(mu/pnew)*tan(dnu/2)*((1-cos(dnu))/pnew - 1/r1 - 1/r2);
        gdot = 1 - (r1/pnew)*(1 - cos(dnu));
        
        e = sqrt(1 - (pnew/a));
        
        % Orbit shape determination
        if e < 1
            cosdE = 1 - (r1/a)*(1 - f);
            sindE = (-fdot*r1*r2)/sqrt(mu*a);
            dE = atan2(sindE,cosdE);
            if dE < 0 && dnu > pi;
                dE = 2*pi + dE;
            elseif dE < 0 && dnu < pi;
                dE = -dE;
            elseif dE > 0 && dnu > pi;
                dE = 2*pi - dE;
            end
            tnew = g + sqrt(a^3/mu)*(dE - sindE);
        elseif e > 1;
            coshF = 1 - (r1/a)*(1 - f);
            dF = log(coshF + sqrt(coshF^2 - 1));
            if dnu > pi;
                dF = -abs(dF);
            elseif dnu < pi;
                dF = abs(dF);
            end
            tnew = g + sqrt((-a)^3/mu)*(sinh(dF) - dF);
        end
        
        % Reassiging the new values to be used
        p1 = p2; t1 = t2;
        p2 = pnew; t2 = tnew;
        
        % Running error calculation
        err = abs(TOF-t2);
    end
    
    % Using values to find velocity vectors
    V1 = (R2 - f*R1)/g;
    V2 = fdot*R1 + gdot*V1;
end

% Newton's Method
if method == 2
    
    while err > TOL
        
        % Finding orbital parameters
        a = (m*k*p1)/((2*m - l^2)*p1^2 + 2*k*l*p1 - k^2);
        
        f = 1 - (r2/p1)*(1 - cos(dnu));
        g = (r1*r2*sin(dnu))/sqrt(mu*p1);
        fdot = sqrt(mu/p1)*tan(dnu/2)*(((1 - cos(dnu))/p1) - (1/r1) - (1/r2));
        gdot = 1 - (r1/p1)*(1 - cos(dnu));
        
        e = sqrt(1 - (p1/a));
        
        % Checks orbital shape and finds time of flight using eccentric anomaly 
        if e<1
            cosdE = 1 - (r1/a)*(1 - f);
            sindE = (-fdot*r1*r2)/sqrt(mu*a);
            dE = atan2(sindE,cosdE);
            if dE < 0 && dnu > pi;
                dE = 2*pi + dE;
            elseif dE < 0 && dnu < pi;
                dE = -dE;
            elseif dE > 0 && dnu > pi;
                dE = 2*pi - dE;
            end
            t = g + sqrt(a^3/mu)*(dE - sindE);
            
            % Equation used in Newton's Method to find next parameter value
            dtdp = -g/(2*p1)-(3/2)*a*(t-g)*((k^2+(2*m-l^2)*p1^2)/(m*k*p1^2))+...
            sqrt(a^3/mu)*((2*k*sindE)/(p1*(k-l*p1)));
        
        elseif e>1
            coshF = 1 - (r1/a)*(1 - f);
            dF = log(coshF + sqrt(coshF^2 - 1));
            if dnu > pi;
                dF = -abs(dF);
            elseif dnu < pi;
                dF = abs(dF);
            end
            t = g + sqrt((-a)^3/mu)*(sinh(dF) - dF);
            
            dtdp = -g/(2*p1)-(3/2)*a*(t-g)*((k^2+(2*m-l^2)*p1^2)/(m*k*p1^2))-...
            sqrt((-a)^3/mu)*((2*k*sinh(dF))/(p1*(k-l*p1)));
        end
        
        % Running error check
        err = abs(TOF - t);
        
        % Solving for a new parameter
        p1  = p1 + (TOF - t)/dtdp;
    
    end
    
    % Velocity vectors
    V1 = (R2 - f*R1)/g;
    V2 = fdot*R1 + gdot*V1;
end


