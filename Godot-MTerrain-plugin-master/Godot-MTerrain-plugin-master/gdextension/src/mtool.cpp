#include "mtool.h"

#include <godot_cpp/variant/utility_functions.hpp>

#include <godot_cpp/classes/engine.hpp>
#include <godot_cpp/classes/editor_script.hpp>
#include <godot_cpp/classes/editor_interface.hpp>


Vector<Node3D*> MTool::editor_cameras;
Vector<Vector3> MTool::editor_cameras_last_pos;
int MTool::camera_index = -1;
bool MTool::editor_plugin_active = false;

void MTool::_bind_methods() {
   ClassDB::bind_static_method("MTool", D_METHOD("get_r16_image","file_path","width","height","min_height","max_height","is_half"), &MTool::get_r16_image);
   ClassDB::bind_static_method("MTool", D_METHOD("write_r16","file_path","data","min_height","max_height"), &MTool::write_r16);
   ClassDB::bind_static_method("MTool", D_METHOD("normalize_rf_data","data","min_height","max_height"), &MTool::normalize_rf_data);
   ClassDB::bind_static_method("MTool", D_METHOD("find_camera","changed_camera"), &MTool::find_editor_camera);
   ClassDB::bind_static_method("MTool", D_METHOD("enable_editor_plugin"), &MTool::enable_editor_plugin);
}


MTool::MTool()
{
}

MTool::~MTool()
{
}


Ref<Image> MTool::get_r16_image(const String& file_path, const uint64_t width, const uint64_t height,double min_height, double max_height,const bool is_half) {
    Ref<Image> img;
    UtilityFunctions::print("open: ", file_path);
    if(!FileAccess::file_exists(file_path)){
        ERR_FAIL_COND_V("File does not exist check your file path again", img);
    }
    Ref<FileAccess> file = FileAccess::open(file_path, FileAccess::READ);
    if(file->get_error() != godot::OK){
        ERR_FAIL_COND_V("Can not open the file", img);
    }
    uint64_t final_width = width;
    uint64_t final_height = height;
    uint64_t size = file->get_length();
    uint64_t size16 = size/2;
    if(width==0 || height==0){
        final_width = sqrt(size16);
        if(final_width*final_width*2 != size){
            ERR_FAIL_COND_V("Image width is not valid please set width and height", img);
        }
        final_height = final_width;
    } else {
        if(width*height != size16){
            ERR_FAIL_COND_V("Image width or height is not valid", img);
        }
    }
    if(is_half){
        PackedByteArray data;
        data.resize(size);
        uint64_t offset = 0;
        for(int i = 0; i<size16; i++){
            double p = (double)file->get_16()/65535;
            p *= (max_height - min_height);
            p += min_height;
            data.encode_half(offset, p);
            offset += 2;
        }
        img = Image::create_from_data(final_width,final_height,false, Image::FORMAT_RH, data);
    } else {
        PackedFloat32Array dataf;
        for(int i = 0; i<size16; i++){
            double p = (double)file->get_16()/65535;
            p *= (max_height - min_height);
            p += min_height;
            dataf.append(p);
        }
        img = Image::create_from_data(final_width,final_height,false, Image::FORMAT_RF, dataf.to_byte_array());
    }
    return img;
}

void MTool::write_r16(const String& file_path,const PackedByteArray& data,double min_height,double max_height){
    ERR_FAIL_COND(data.size()%4!=0);
    double dh = max_height - min_height;
    ERR_FAIL_COND(dh<0);
    Ref<FileAccess> file = FileAccess::open(file_path,FileAccess::ModeFlags::WRITE);
    const float* ptr = (float*)data.ptr();
    uint32_t size = data.size()/4;

    for(uint32_t i=0;i<size;i++){
        double val = (ptr[i] - min_height)/dh;
        if (val < 0){
            val = 0;
        }
        val *= 65535;
        if(val > 65535){
            val = 65535;
        }
        uint16_t u16 = val;
        file->store_16(u16);
    }
    file->close();
}

PackedByteArray MTool::normalize_rf_data(const PackedByteArray& data,double min_height,double max_height){
    ERR_FAIL_COND_V(data.size()%4!=0,data);
    double dh = max_height - min_height;
    ERR_FAIL_COND_V(dh<0,data);
    const float* ptr = (const float*)data.ptr();
    PackedByteArray out;
    out.resize(data.size());
    float* ptrw = (float*)out.ptrw();
    uint32_t size = data.size()/4;
    for(uint32_t i=0;i<size;i++){
        double val = (ptr[i] - min_height)/dh;
        if (val < 0){
            val = 0;
        }
        if(val>1.0){
            val = 1.0;
        }
        ptrw[i] = val;
    }
    return out;
}

Node3D* MTool::find_editor_camera(bool changed_camera){
	if (Engine::get_singleton()->is_editor_hint()) {
        if(editor_cameras.size()==0){
            EditorScript script;
            EditorInterface *edit_interface = script.get_editor_interface();
            Node* main_screen = (Node*)edit_interface->get_editor_main_screen();
            Node* edit_scene_root = edit_interface->get_edited_scene_root();
            TypedArray<Node> process_nodes;
            process_nodes.push_back(main_screen);
            while (process_nodes.size() > 0)
            {
                Node* current_node = Object::cast_to<Node>(process_nodes[process_nodes.size() - 1]);
                process_nodes.remove_at(process_nodes.size() - 1);
                if(current_node==edit_scene_root){
                    continue;
                }
                if(current_node->is_class("Camera3D")){
                    editor_cameras.push_back(Object::cast_to<Node3D>(current_node));
                }
                process_nodes.append_array(current_node->get_children());
            }
            for(int i=0; i < editor_cameras.size(); i++){
                editor_cameras_last_pos.push_back(editor_cameras[i]->get_global_position());
            }
            if(editor_cameras.size()!=0){
                return editor_cameras[editor_cameras.size() - 1]; // Return last element
            } else {
                return nullptr;
            }
        }
        if(changed_camera){
            for(int i=editor_cameras.size() - 1; i >= 0 ; i--){
                if(editor_cameras[i]->get_global_position() != editor_cameras_last_pos[i]){
                    camera_index = i; // updating to camera which changed
                    break;
                }
            }
            for(int i=0; i < editor_cameras.size(); i++){
                editor_cameras_last_pos.set(i,editor_cameras[i]->get_global_position());
            }
            if(editor_cameras.size() - 1 >= camera_index && camera_index!=-1){
                return editor_cameras[camera_index];
            }
        }
        if(editor_cameras.size()!=0){
            return editor_cameras[editor_cameras.size() - 1]; // Return last element
        } else {
            return nullptr;
        }
	}
    return nullptr;
}

void MTool::enable_editor_plugin(){
    editor_plugin_active = true;
}

bool MTool::is_editor_plugin_active(){
    return editor_plugin_active;
}