// %BANNER_BEGIN%
// ---------------------------------------------------------------------
// %COPYRIGHT_BEGIN%
//
// Copyright (c) 2018 Magic Leap, Inc. All Rights Reserved.
// Use of this file is governed by the Creator Agreement, located
// here: https://id.magicleap.com/creator-terms
//
// %COPYRIGHT_END%
// ---------------------------------------------------------------------
// %BANNER_END%

#if UNITY_EDITOR || PLATFORM_LUMIN

using UnityEngine;
using UnityEngine.Experimental.XR;
using UnityEngine.XR.MagicLeap;

namespace MagicLeap
{
    /// <summary>
    /// This class allows you to change meshing properties at runtime, including the rendering mode.
    /// Manages the MLSpatialMapper behaviour and tracks the meshes.
    /// </summary>
    public class cleARsightVisualizer : MonoBehaviour
    {
        public enum RenderMode
        {
            None,
            Outline,
            HoriPlane,
            Both
        }

        #region Private Variables
        [SerializeField, Tooltip("The MLSpatialMapper from which to get update on mesh types.")]
        private MLSpatialMapper _mlSpatialMapper;

        [SerializeField, Tooltip("The material to apply for Both.")]
        private Material _BothMaterial;

        [SerializeField, Tooltip("The material to apply for Outline rendering.")]
        private Material _OutlineMaterial;

        [SerializeField, Tooltip("The material to apply for point cloud rendering.")]
        private Material _HoriPlaneMaterial;

        private RenderMode _renderMode = RenderMode.Outline;
        #endregion

        #region Unity Methods
        /// <summary>
        /// Start listening for MLSpatialMapper events.
        /// </summary>
        void Awake()
        {
            // Validate all required game objects.
            if (_mlSpatialMapper == null)
            {
                Debug.LogError("Error: MeshingVisualizer._mlSpatialMapper is not set, disabling script!");
                enabled = false;
                return;
            }
            if (_BothMaterial == null)
            {
                Debug.LogError("Error: MeshingVisualizer._BothMaterial is not set, disabling script!");
                enabled = false;
                return;
            }
            if (_OutlineMaterial == null)
            {
                Debug.LogError("Error: MeshingVisualizer._OutlineMaterial is not set, disabling script!");
                enabled = false;
                return;
            }
            if (_HoriPlaneMaterial == null)
            {
                Debug.LogError("Error: MeshingVisualizer._HoriPlaneMaterial is not set, disabling script!");
                enabled = false;
                return;
            }
        }

        /// <summary>
        /// Register for new and updated freagments.
        /// </summary>
        void Start()
        {
            _mlSpatialMapper.meshAdded += HandleOnMeshReady;
            _mlSpatialMapper.meshUpdated += HandleOnMeshReady;
        }

        /// <summary>
        /// Unregister callbacks.
        /// </summary>
        void OnDestroy()
        {
            _mlSpatialMapper.meshAdded -= HandleOnMeshReady;
            _mlSpatialMapper.meshUpdated -= HandleOnMeshReady;
        }
        #endregion

        #region Public Methods
        /// <summary>
        /// Set the render material on the meshes.
        /// </summary>
        /// <param name="mode">The render mode that should be used on the material.</param>
        public void SetRenderers(RenderMode mode)
        {
            // Set the render mode.
            _renderMode = mode;

            // Clear existing meshes to process the new mesh type.
            switch (_renderMode)
            {
                case RenderMode.Outline:
                case RenderMode.Both:
                    {
                        _mlSpatialMapper.DestroyAllMeshes();
                        _mlSpatialMapper.RefreshAllMeshes();

                        _mlSpatialMapper.meshType = MLSpatialMapper.MeshType.Triangles;

                        break;
                    }
                case RenderMode.HoriPlane:
                    {
                        _mlSpatialMapper.DestroyAllMeshes();
                        _mlSpatialMapper.RefreshAllMeshes();

                        //_mlSpatialMapper.meshType = MLSpatialMapper.MeshType.HoriPlane;

                        break;
                    }
            }

            // Update the material applied to all the MeshRenderers.
            foreach (GameObject fragment in _mlSpatialMapper.meshIdToGameObjectMap.Values)
            {
                UpdateRenderer(fragment.GetComponent<MeshRenderer>());
            }
        }
        #endregion

        #region Private Methods
        /// <summary>
        /// Updates the currently selected render material on the MeshRenderer.
        /// </summary>
        /// <param name="meshRenderer">The MeshRenderer that should be updated.</param>
        private void UpdateRenderer(MeshRenderer meshRenderer)
        {
            if (meshRenderer != null)
            {
                // Toggle the GameObject(s) and set the correct materia based on the current RenderMode.
                if (_renderMode == RenderMode.None)
                {
                    meshRenderer.enabled = false;
                }
                else if (_renderMode == RenderMode.HoriPlane)
                {
                    meshRenderer.enabled = true;
                    meshRenderer.material = _HoriPlaneMaterial;
                }
                else if (_renderMode == RenderMode.Outline)
                {
                    meshRenderer.enabled = true;
                    meshRenderer.material = _OutlineMaterial;
                }
                else if (_renderMode == RenderMode.Both)
                {
                    meshRenderer.enabled = true;
                    meshRenderer.material = _BothMaterial;
                }
            }
        }
        #endregion

        #region Event Handlers
        /// <summary>
        /// Handles the MeshReady event, which tracks and assigns the correct mesh renderer materials.
        /// </summary>
        /// <param name="meshId">Id of the mesh that got added / upated.</param>
        private void HandleOnMeshReady(TrackableId meshId)
        {
            if (_mlSpatialMapper.meshIdToGameObjectMap.ContainsKey(meshId))
            {
                UpdateRenderer(_mlSpatialMapper.meshIdToGameObjectMap[meshId].GetComponent<MeshRenderer>());
            }
        }
        #endregion
    }
}

#endif
