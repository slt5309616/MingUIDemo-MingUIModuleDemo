using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Scripts.Com.MingUI;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor
{
    [CustomEditor(typeof(CCanvas))]
    class CCanvasInspector:UISpriteInspector
    {
        private SerializedObject tar;
        protected override void DrawCustomProperties()
        {
            NGUIEditorTools.DrawProperty("Content", serializedObject, "Content");
            NGUIEditorTools.DrawProperty("Bar", serializedObject, "Bar");
            NGUIEditorTools.DrawProperty("hBar", serializedObject, "hBar");
            NGUIEditorTools.DrawProperty("Mask", serializedObject, "Mask");
            
            tar = new SerializedObject(target);
            SerializedProperty mask=tar.FindProperty("Mask");
            if (mask != null)
            {
//                mask.baseClipRegion=
            }
            base.DrawCustomProperties();

        }
    }
}
