package templates

import (
	"time"

	"github.com/aquasecurity/starboard/pkg/apis/aquasecurity/v1alpha1"
	"github.com/aquasecurity/starboard/pkg/kube"
)

// WorkloadReport is a structure that holds data to render
// an HTML report for a specified K8s workload.
type WorkloadReport struct {
	Workload    kube.Object
	GeneratedAt time.Time

	// FIXME Do not use map as the order of iteration is unpredictable.
	VulnsReports      map[string]v1alpha1.VulnerabilityScanResult
	ConfigAuditReport *v1alpha1.ConfigAuditReport
}

// NamespaceReport is a structure that holds data to render
// an HTML report for a specified K8s namespace.
type NamespaceReport struct {
	Namespace   kube.Object
	GeneratedAt time.Time

	Top5VulnerableImages []v1alpha1.VulnerabilityReport
	Top5FailedChecks     []CheckWithCount
	Top5Vulnerability    []VulnerabilityWithCount
}

type VulnerabilityWithCount struct {
	v1alpha1.Vulnerability
	AffectedWorkloads int
}

type CheckWithCount struct {
	v1alpha1.Check
	AffectedWorkloads int
}

// NodeReport is a structure that holds data to render
// an HTML report for a specified K8s node.
type NodeReport struct {
	Node        kube.Object
	GeneratedAt time.Time

	CisKubeBenchReport *v1alpha1.CISKubeBenchReport
}
