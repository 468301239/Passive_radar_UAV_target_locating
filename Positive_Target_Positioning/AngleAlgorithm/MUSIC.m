% MUSIC �㷨
% 1������1��signal �ź�
% 2������2��K ��Դ��Ŀ
% 3������3����λ�������Ŀ
% 4������4�������������Ŀ
function theta_range = MUSIC(signal, K, azNum, elNum, f0, r0)
    if nargin == 1
        K = 8;
        azNum = 360;
        elNum = 90;
        f0 = 1e6;
        r0 = 5.0;
    end
    M = size(signal, 1);   
    N = size(signal, 2);      
    c      = 3e8;      % ����
    lambda = c / f0;   % ����
    
    Rs = signal * signal' / N;  % ����ؾ��� 
    % ����ֵ�ֽ�
    [EV,D] = eig(Rs);       % ����ֵ�ֽ�
    EVA = diag(D)';         % ������ֵ����Խ�����ȡ��תΪһ��
    [EVA,I] = sort(EVA);    % ������ֵ���� ��С����
    EV = fliplr(EV(:,I));   % ��Ӧ����ʸ������
    
    % �����ռ���
    theta_range = [];
    for az = 1:azNum
        angleAz = 2 * pi / azNum * az;
        for el = 1:elNum
            angleEl = pi / 2 / elNum * el;
            % �ӳ�ʱ��
            tau = r0 / lambda * cos(angleAz - 2 * pi * (0:M-1) / M) * sin(angleEl);
            % ����ʸ��
            A   = exp(1j * 2 * pi * tau);
            En  = EV(:,K+1:M);             % ȡ����ĵ�M+1��N����������ӿռ�
            theta_range(az, el)=1/(A*En*En'*A');
        end
        
    end
end