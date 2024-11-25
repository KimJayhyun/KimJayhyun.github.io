# 0. 시작하기 전에
- **호환되는 리눅스 머신**: 쿠버네티스 프로젝트는 데비안 기반 배포판, 레드햇 기반 배포판, 그리고 패키지 매니저를 사용하지 않는 경우에 대한 일반적인 가이드를 제공한다.
- **2 GB 이상의 RAM**: 2 GB 이하의 RAM을 가진 머신은 사용자의 앱을 위한 공간이 거의 남지 않음.
- **2개 이상의 CPU**: 클러스터의 모든 머신에 걸쳐 전체 네트워크 연결 필요 (공용 또는 사설 네트워크면 괜찮음).
- **고유한 정보**: 모든 노드에 대해 고유한 호스트 이름, MAC 주소 및 product_uuid가 필요하다. [자세한 내용은 여기를 참고한다.](https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#verify-mac-address)
- **포트 개방**: 컴퓨터의 특정 포트들이 개방되어야 한다. [자세한 내용은 여기를 참고한다.](https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports)
- **스왑 비활성화**: kubelet이 제대로 작동하게 하려면 반드시 스왑을 사용하지 않도록 설정한다.



## IPv4를 포워딩하여 iptables가 브리지된 트래픽을 보게 하기
- [공식문서](https://kubernetes.io/ko/docs/setup/production-environment/container-runtimes/#ipv4%EB%A5%BC-%ED%8F%AC%EC%9B%8C%EB%94%A9%ED%95%98%EC%97%AC-iptables%EA%B0%80-%EB%B8%8C%EB%A6%AC%EC%A7%80%EB%90%9C-%ED%8A%B8%EB%9E%98%ED%94%BD%EC%9D%84-%EB%B3%B4%EA%B2%8C-%ED%95%98%EA%B8%B0)


```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# 필요한 sysctl 파라미터를 설정하면, 재부팅 후에도 값이 유지된다.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 재부팅하지 않고 sysctl 파라미터 적용하기
sudo sysctl --system
```

---

## Swap 비활성화
```bash
swapoff -a && sed -i '/ swap / s/^/#/' /etc/fstab
```

---

## containerd - Container Runtime 설치
```bash
yum install -y containerd
systemctl daemon-reload
systemctl enable --now containerd
```

### containerd의 cgroup 드라이버 구성
```yaml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```

위와 같이 `SystemdCgroup`을 `true`로 수정

```bash
containerd config default > /etc/containerd/config.toml
sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd
```

---

# 1. kubectl & kubeadm 설치

- ~~[kubectl install](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)~~

- [kubeadm install](https://kubernetes.io/ko/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# permissive 모드로 SELinux 설정(효과적으로 비활성화)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

sudo systemctl enable --now kubelet

마지막 메타자료 만료확인(0:08:35 이전): 2024년 10월 01일 (화) 오전 03시 45분 28초.
종속성이 해결되었습니다.
========================================================================================================================================================================================================================================================================================
 꾸러미                                                                      구조                                                        버전                                                                     저장소                                                           크기
========================================================================================================================================================================================================================================================================================
설치 중:
 kubeadm                                                                     x86_64                                                      1.31.1-150500.1.1                                                        kubernetes                                                       11 M
 kubectl                                                                     x86_64                                                      1.31.1-150500.1.1                                                        kubernetes                                                       11 M
 kubelet                                                                     x86_64                                                      1.31.1-150500.1.1                                                        kubernetes                                                       15 M
종속 꾸러미 설치 중:
 conntrack-tools                                                             x86_64                                                      1.4.4-11.el8                                                             baseos                                                          203 k
 cri-tools                                                                   x86_64                                                      1.31.1-150500.1.1                                                        kubernetes                                                      6.9 M
 kubernetes-cni                                                              x86_64                                                      1.5.1-150500.1.1                                                         kubernetes                                                      7.1 M
 libnetfilter_cthelper                                                       x86_64                                                      1.0.0-15.el8                                                             baseos                                                           23 k
 libnetfilter_cttimeout                                                      x86_64                                                      1.0.0-11.el8                                                             baseos                                                           23 k
 libnetfilter_queue                                                          x86_64                                                      1.0.4-3.el8                                                              baseos                                                           30 k

연결 요약
========================================================================================================================================================================================================================================================================================

```

