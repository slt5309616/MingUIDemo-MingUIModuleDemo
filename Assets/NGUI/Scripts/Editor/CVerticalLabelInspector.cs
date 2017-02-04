using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Assets.Scripts.Com.MingUI;
using UnityEditor;

namespace Assets.NGUI.Scripts.Editor {
    [CustomEditor(typeof(CVerticalLabel))]
    internal class CVerticalLabelInspector : UISpriteInspector {
        protected override void DrawCustomProperties() {
            base.DrawCustomProperties();
            NGUIEditorTools.DrawProperty("isLeftToRight", serializedObject, "isLeftToRight");
            NGUIEditorTools.DrawProperty("msgItems", serializedObject, "msgItems");
            NGUIEditorTools.DrawProperty("columeDistance", serializedObject, "columeDistance");
            
        }
    }
}