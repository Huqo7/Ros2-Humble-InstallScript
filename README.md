# Ros2-Humble-InstallScript
A simple install script that installs ROS2 Humble for Ubuntu 22.04

## Environment
The script also sets up workspace folders in **/workspaces**. One for third party workspaces and one for personal workspaces. It also ads the ros2 source to .bashrc

## Third party workspaces
The script gives the option to install a couple of third party workspaces. If the option is chosen the following workspaces are installed, built and source is added to .bashrc.
* https://github.com/UniversalRobots/Universal_Robots_ROS2_Gazebo_Simulation
* https://github.com/ros/urdf_tutorial
