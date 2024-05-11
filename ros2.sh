#!/bin/bash

clear
figlet -kcf slant ROS-2
figlet -kcf smslant Environment

if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
fi

if [[ $VER != "22.04" ]]; then
  echo "Wrong Ubuntu Version - Please Use Ubuntu Jammy"
  exit
fi

sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update

sudo apt install ros-humble-desktop

if grep -Fxq "source /opt/ros/humble/setup.bash" ~/.bashrc
then
  echo "Already Sourced"
else 
  echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
fi

source /opt/ros/humble/setup.bash

sudo apt install ros-dev-tools
sudo rosdep init
rosdep update

while true; do

read -p "Do you want to install third party workspaces? (y/n) " yn
  THIRD="false"
  case $yn in 
	  [yY] ) echo installing;
      THIRD="true"
		  break;;
	  [nN] ) echo continuing;
		  THIRD="false"
      break;;
	  * ) echo invalid response;;
  esac

done

WORKSPACE="/workspaces"
sudo mkdir -p ${WORKSPACE}
sudo chmod -R 777 ${WORKSPACE}

if [ $THIRD = "true" ]; then
  THIRD_PARTY="${WORKSPACE}/3rd_party_ws"
  
  if [ ! -d "${THIRD_PARTY}/src" ]; then
    mkdir -p "${THIRD_PARTY}/src"
  fi
  
  pushd $THIRD_PARTY
  git clone -b ros2 https://github.com/ros/urdf_tutorial.git ${THIRD_PARTY}/src/urdf_tutorial
  git clone -b humble https://github.com/UniversalRobots/Universal_Robots_ROS2_Gazebo_Simulation.git ${THIRD_PARTY}/src/Universal_Robots_ROS2_Gazebo_Simulation
  rosdep install --from-paths src --ignore-src --rosdistro humble -y
  colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
  
  if grep -Fxq "source $THIRD_PARTY/install/setup.bash" ~/.bashrc
  then
    echo "Already Sourced"
  else 
    echo "source $THIRD_PARTY/install/setup.bash" >> ~/.bashrc
  fi
  source ${THIRD_PARTY_WS}/install/setup.bash
fi

MAIN="${WORKSPACE}/ros2_ws"
if [ ! -d "${MAIN}/src" ]; then
  mkdir -p "${MAIN}/src"
fi


